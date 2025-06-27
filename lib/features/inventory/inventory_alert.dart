// features/inventory/inventory_alerts.dart
import 'package:flutter/material.dart';

import '../../core/database/database_helper.dart';

class InventoryAlerts {
  final DatabaseHelper _databaseHelper;

  InventoryAlerts(this._databaseHelper);

  Future<List<Map<String, dynamic>>> getLowStockItems() async {
    final List<Map<String, dynamic>> items = await _databaseHelper.getLowStockItems();
    return items.where((item) {
      final int quantity = item['quantity'] as int? ?? 0;
      final int minStock = item['min_stock_level'] as int? ?? 5;
      return quantity <= minStock;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getExpiringItems() async {
    // Implement logic for items with expiry dates
    return [];
  }

  Future<int> getTotalAlerts() async {
    final lowStock = await getLowStockItems();
    final expiring = await getExpiringItems();
    return lowStock.length + expiring.length;
  }

  Future<void> checkAndNotifyAlerts(BuildContext context) async {
    final alertsCount = await getTotalAlerts();
    if (alertsCount > 0) {
      _showAlertNotification(context, alertsCount);
    }
  }

  void _showAlertNotification(BuildContext context, int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count inventory alerts need your attention'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            Navigator.pushNamed(context, '/inventory/alerts');
          },
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }
}

// Inventory Alerts Screen
class InventoryAlertsScreen extends StatefulWidget {
  @override
  _InventoryAlertsScreenState createState() => _InventoryAlertsScreenState();
}

class _InventoryAlertsScreenState extends State<InventoryAlertsScreen> {
  late Future<List<Map<String, dynamic>>> _lowStockItems;
  late Future<List<Map<String, dynamic>>> _expiringItems;

  @override
  void initState() {
    super.initState();
    final inventoryAlerts = InventoryAlerts(DatabaseHelper.instance);
    _lowStockItems = inventoryAlerts.getLowStockItems();
    _expiringItems = inventoryAlerts.getExpiringItems();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inventory Alerts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Low Stock'),
              Tab(text: 'Expiring Soon'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLowStockTab(),
            _buildExpiringTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _lowStockItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading low stock items'));
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(child: Text('No low stock items'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.warning, color: Colors.orange),
              ),
              title: Text(item['name']),
              subtitle: Text(
                  'Current: ${item['quantity']} | Min: ${item['min_stock_level'] ?? 5}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => _createPurchaseOrder(context, item),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpiringTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _expiringItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading expiring items'));
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(child: Text('No items expiring soon'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.timer, color: Colors.red),
              ),
              title: Text(item['name']),
              subtitle: Text('Expires on: ${item['expiry_date']}'),
              trailing: IconButton(
                icon: Icon(Icons.sell),
                onPressed: () => _createSaleForExpiring(context, item),
              ),
            );
          },
        );
      },
    );
  }

  void _createPurchaseOrder(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/purchases/new',
      arguments: {
        'item_id': item['id'],
        'quantity': (item['min_stock_level'] ?? 5) * 2 - item['quantity'],
      },
    );
  }

  void _createSaleForExpiring(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/sales/new',
      arguments: {
        'item_id': item['id'],
        'quantity': item['quantity'],
        'discount': 0.2, // 20% discount for expiring items
      },
    );
  }
}