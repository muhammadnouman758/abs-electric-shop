import 'package:flutter/material.dart';
class AutoPurchaseOrderScreen extends StatefulWidget {
  @override
  _AutoPurchaseOrderScreenState createState() => _AutoPurchaseOrderScreenState();
}

class _AutoPurchaseOrderScreenState extends State<AutoPurchaseOrderScreen> {
  List<Map<String, dynamic>> _lowStockItems = [];
  List<Map<String, dynamic>> _selectedSuppliers = [];
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadLowStockItems();
    _loadSuppliers();
  }

  Future<void> _loadLowStockItems() async {
    // Replace with actual database query
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _lowStockItems = [
        {
          'id': 1,
          'name': 'Copper Wire 2.5mm',
          'current_stock': 15,
          'min_stock': 50,
          'supplier_id': 1,
          'supplier_name': 'Wire Solutions Inc.',
        },
        {
          'id': 2,
          'name': 'LED Bulb 9W',
          'current_stock': 20,
          'min_stock': 100,
          'supplier_id': 2,
          'supplier_name': 'Lighting World',
        },
        {
          'id': 3,
          'name': 'Switch Socket',
          'current_stock': 30,
          'min_stock': 80,
          'supplier_id': 3,
          'supplier_name': 'Electrical Components Ltd.',
        },
      ];
    });
  }

  Future<void> _loadSuppliers() async {
    // Replace with actual database query
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _selectedSuppliers = [
        {'id': 1, 'name': 'Wire Solutions Inc.', 'selected': true},
        {'id': 2, 'name': 'Lighting World', 'selected': true},
        {'id': 3, 'name': 'Electrical Components Ltd.', 'selected': true},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Purchase Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadLowStockItems,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _lowStockItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView(
              children: [
                _buildSupplierSelection(),
                _buildLowStockItems(),
              ],
            ),
          ),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildSupplierSelection() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Suppliers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ..._selectedSuppliers.map((supplier) {
              return CheckboxListTile(
                title: Text(supplier['name']),
                value: supplier['selected'],
                onChanged: (value) {
                  setState(() {
                    supplier['selected'] = value;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItems() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Low Stock Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Item',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Current',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Min',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Order Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ..._lowStockItems.map((item) {
                  final orderQty = (item['min_stock'] * 2 - item['current_stock'])
                      .clamp(10, 1000); // Minimum order of 10
                  return TableRow(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(item['name']),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          item['current_stock'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: item['current_stock'] < item['min_stock']
                                ? Colors.red
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          item['min_stock'].toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          orderQty.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50), backgroundColor: _isGenerating ? Colors.grey : Theme.of(context).primaryColor,
        ),
        onPressed: _isGenerating ? null : _generatePurchaseOrders,
        child: _isGenerating
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          'GENERATE PURCHASE ORDERS',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _generatePurchaseOrders() async {
    setState(() => _isGenerating = true);

    // Get selected suppliers
    final selectedSupplierIds = _selectedSuppliers
        .where((supplier) => supplier['selected'])
        .map((supplier) => supplier['id'])
        .toList();

    // Group items by supplier
    final itemsBySupplier = <int, List<Map<String, dynamic>>>{};
    for (final item in _lowStockItems) {
      if (selectedSupplierIds.contains(item['supplier_id'])) {
        if (!itemsBySupplier.containsKey(item['supplier_id'])) {
          itemsBySupplier[item['supplier_id']] = [];
        }
        itemsBySupplier[item['supplier_id']]!.add(item);
      }
    }

    // Generate purchase orders
    for (final supplierId in itemsBySupplier.keys) {
      final supplierItems = itemsBySupplier[supplierId]!;
      final supplier = _selectedSuppliers.firstWhere(
              (s) => s['id'] == supplierId);

      // Create purchase order in database
      // await _databaseHelper.createPurchaseOrder(
      //   supplierId: supplierId,
      //   items: supplierItems,
      // );

      // For demo, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Created PO for ${supplier['name']} with ${supplierItems.length} items'),
        ),
      );
    }

    setState(() => _isGenerating = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generated ${itemsBySupplier.length} purchase orders'),
      ),
    );
  }
}