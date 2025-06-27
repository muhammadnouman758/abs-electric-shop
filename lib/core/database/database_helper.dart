
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('electric_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    // Items table
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        purchase_price REAL NOT NULL,
        sale_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        min_stock_level INTEGER DEFAULT 5,
        barcode TEXT,
        expiry_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // Purchases table
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        supplier TEXT,
        purchase_date TEXT NOT NULL,
        invoice_number TEXT,
        is_synced INTEGER DEFAULT 0,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
      )
    ''');

    // Sales table
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_date TEXT NOT NULL,
        customer_name TEXT,
        customer_contact TEXT,
        total_amount REAL NOT NULL,
        discount REAL DEFAULT 0,
        tax REAL DEFAULT 0,
        payment_method TEXT,
        invoice_number TEXT UNIQUE,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Sale items junction table
    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE,
        FOREIGN KEY (item_id) REFERENCES items (id)
      )
    ''');

    // Financial records
    await db.execute('''
      CREATE TABLE financial_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        record_date TEXT NOT NULL,
        type TEXT NOT NULL, -- 'sale', 'purchase', 'expense', etc.
        amount REAL NOT NULL,
        description TEXT,
        reference_id INTEGER, -- links to sale/purchase ID
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // Inventory alerts table
    await db.execute('''
      CREATE TABLE inventory_alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        alert_type TEXT NOT NULL, -- 'low_stock', 'expiring_soon', 'expired'
        alert_date TEXT NOT NULL,
        is_resolved INTEGER DEFAULT 0,
        resolved_date TEXT,
        resolved_action TEXT,
        FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_items_category ON items(category)');
    await db.execute('CREATE INDEX idx_items_quantity ON items(quantity)');
    await db.execute('CREATE INDEX idx_items_min_stock ON items(min_stock_level)');
    await db.execute('CREATE INDEX idx_alerts_item_id ON inventory_alerts(item_id)');
    await db.execute('CREATE INDEX idx_alerts_resolved ON inventory_alerts(is_resolved)');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE inventory_alerts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          item_id INTEGER NOT NULL,
          alert_type TEXT NOT NULL,
          alert_date TEXT NOT NULL,
          is_resolved INTEGER DEFAULT 0,
          resolved_date TEXT,
          resolved_action TEXT,
          FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
        )
      ''');
      await db.execute('ALTER TABLE items ADD COLUMN expiry_date TEXT');
      await db.execute('ALTER TABLE items ADD COLUMN is_active INTEGER DEFAULT 1');
      await db.execute('CREATE INDEX idx_alerts_item_id ON inventory_alerts(item_id)');
    }
  }

  // ================== Inventory Alert Methods ==================

  /// Checks for low stock items and creates alerts if needed
  Future<void> checkLowStockItems() async {
    final db = await instance.database;

    // Get items below minimum stock level
    final List<Map<String, dynamic>> lowStockItems = await db.query(
      'items',
      where: 'quantity <= min_stock_level AND is_active = 1',
    );

    // Create alerts for low stock items
    for (final item in lowStockItems) {
      // Check if alert already exists and is unresolved
      final existingAlerts = await db.query(
        'inventory_alerts',
        where: 'item_id = ? AND alert_type = ? AND is_resolved = 0',
        whereArgs: [item['id'], 'low_stock'],
      );

      if (existingAlerts.isEmpty) {
        await db.insert('inventory_alerts', {
          'item_id': item['id'],
          'alert_type': 'low_stock',
          'alert_date': DateTime.now().toIso8601String(),
          'is_resolved': 0,
        });
      }
    }
  }

  /// Checks for expiring items and creates alerts if needed
  Future<void> checkExpiringItems({int daysThreshold = 30}) async {
    final db = await instance.database;
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold)).toIso8601String();

    // Get items that will expire within the threshold
    final List<Map<String, dynamic>> expiringItems = await db.query(
      'items',
      where: 'expiry_date IS NOT NULL AND expiry_date <= ? AND is_active = 1',
      whereArgs: [thresholdDate],
    );

    // Create alerts for expiring items
    for (final item in expiringItems) {
      // Check if alert already exists and is unresolved
      final existingAlerts = await db.query(
        'inventory_alerts',
        where: 'item_id = ? AND alert_type = ? AND is_resolved = 0',
        whereArgs: [item['id'], 'expiring_soon'],
      );

      if (existingAlerts.isEmpty) {
        await db.insert('inventory_alerts', {
          'item_id': item['id'],
          'alert_type': 'expiring_soon',
          'alert_date': DateTime.now().toIso8601String(),
          'is_resolved': 0,
        });
      }
    }
  }

  /// Gets all active inventory alerts
  Future<List<Map<String, dynamic>>> getInventoryAlerts({bool includeResolved = false}) async {
    final db = await instance.database;
    final where = includeResolved ? null : 'is_resolved = 0';
    return await db.query(
      'inventory_alerts',
      where: where,
      orderBy: 'alert_date DESC',
    );
  }

  /// Gets alerts for a specific item
  Future<List<Map<String, dynamic>>> getItemAlerts(int itemId) async {
    final db = await instance.database;
    return await db.query(
      'inventory_alerts',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'alert_date DESC',
    );
  }

  /// Marks an alert as resolved
  Future<int> resolveAlert(int alertId, {String? actionTaken}) async {
    final db = await instance.database;
    return await db.update(
      'inventory_alerts',
      {
        'is_resolved': 1,
        'resolved_date': DateTime.now().toIso8601String(),
        'resolved_action': actionTaken,
      },
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }

  /// Gets low stock items (quantity <= min_stock_level)
  Future<List<Map<String, dynamic>>> getLowStockItems() async {
    final db = await instance.database;
    return await db.query(
      'items',
      where: 'quantity <= min_stock_level AND is_active = 1',
      orderBy: 'quantity ASC',
    );
  }

  /// Gets expiring soon items (within 30 days)
  Future<List<Map<String, dynamic>>> getExpiringSoonItems({int daysThreshold = 30}) async {
    final db = await instance.database;
    final thresholdDate = DateTime.now().add(Duration(days: daysThreshold)).toIso8601String();
    return await db.query(
      'items',
      where: 'expiry_date IS NOT NULL AND expiry_date <= ? AND is_active = 1',
      whereArgs: [thresholdDate],
      orderBy: 'expiry_date ASC',
    );
  }

  /// Gets the count of unresolved alerts
  Future<int> getUnresolvedAlertCount() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM inventory_alerts WHERE is_resolved = 0'
    );
    return result.first['count'] as int;
  }

  // ================== Item Management Methods ==================

  /// Updates item quantity and checks for alerts
  Future<void> updateItemQuantity(int itemId, int newQuantity) async {
    final db = await instance.database;

    await db.update(
      'items',
      {
        'quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // Check if this quantity change triggers any alerts
    await checkLowStockItems();
  }

  /// Adds quantity to existing stock
  Future<void> addItemQuantity(int itemId, int quantityToAdd) async {
    final db = await instance.database;

    await db.rawUpdate(
      'UPDATE items SET quantity = quantity + ?, updated_at = ? WHERE id = ?',
      [quantityToAdd, DateTime.now().toIso8601String(), itemId],
    );

    // Check if this resolves any low stock alerts
    final item = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // if (item.isNotEmpty && item.first['quantity']! > item.first['min_stock_level']) {
    if (item.isNotEmpty ) {
      await db.update(
        'inventory_alerts',
        {
          'is_resolved': 1,
          'resolved_date': DateTime.now().toIso8601String(),
          'resolved_action': 'restocked',
        },
        where: 'item_id = ? AND alert_type = ? AND is_resolved = 0',
        whereArgs: [itemId, 'low_stock'],
      );
    }
  }

// ================== Other Database Methods ==================
// ... (keep all your existing database methods here)
}