// features/inventory/inventory_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add, size: 20, color: Colors.white),
              ),
              onPressed: () => _navigateToAddItem(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          SizedBox(height: 8),
          _buildStatsRow(),
          SizedBox(height: 16),
          Expanded(
            child: _buildInventoryList(),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667EEA).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () => _navigateToAddItem(context),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search inventory items...',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search, color: Colors.white, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.clear, size: 16, color: Colors.grey[600]),
              ),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            )
                : null,
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    // Replace with actual data from database
    List<Map<String, dynamic>> dummyItems = List.generate(20, (index) {
      return {
        'id': index + 1,
        'name': 'Electrical Item ${index + 1}',
        'category': ['Wires', 'Switches', 'Lights', 'Tools'][index % 4],
        'quantity': 100 + index * 5,
        'purchase_price': 10.0 + index.toDouble(),
        'sale_price': 15.0 + index.toDouble(),
        'min_stock_level': 20,
      };
    });

    final totalItems = dummyItems.length;
    final lowStockItems = dummyItems.where((item) => item['quantity'] < item['min_stock_level']).length;
    final totalValue = dummyItems.fold(0.0, (sum, item) => sum + (item['quantity'] * item['sale_price']));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Items',
              totalItems.toString(),
              Icons.inventory_2_rounded,
              [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Low Stock',
              lowStockItems.toString(),
              Icons.warning_rounded,
              [Color(0xFFFFB347), Color(0xFFFFCC33)],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Value',
              '\$${totalValue.toStringAsFixed(0)}',
              Icons.attach_money_rounded,
              [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> gradientColors) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    // Replace with actual data from database
    List<Map<String, dynamic>> dummyItems = List.generate(20, (index) {
      return {
        'id': index + 1,
        'name': 'Electrical Item ${index + 1}',
        'category': ['Wires', 'Switches', 'Lights', 'Tools'][index % 4],
        'quantity': 100 + index * 5,
        'purchase_price': 10.0 + index.toDouble(),
        'sale_price': 15.0 + index.toDouble(),
        'min_stock_level': 20,
      };
    });

    // Filter items based on search query
    final filteredItems = dummyItems.where((item) {
      final name = item['name'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();

    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isLowStock = item['quantity'] < item['min_stock_level'];

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getCategoryGradient(item['category']),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item['name'][0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                if (isLowStock)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Low Stock',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['category'],
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Stock: ${item['quantity']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '\$${item['sale_price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.blue, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                    value: 'details',
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.orange, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                    value: 'delete',
                  ),
                ],
                onSelected: (value) => _handleItemAction(value, item),
              ),
            ),
            onTap: () => _navigateToItemDetails(context, item),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA).withOpacity(0.1), Color(0xFF764BA2).withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Color(0xFF667EEA),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'No items match your search criteria'
                : 'Add your first inventory item to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddItem(context),
            icon: Icon(Icons.add),
            label: Text('Add Item'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Wires':
        return [Color(0xFF667EEA), Color(0xFF764BA2)];
      case 'Switches':
        return [Color(0xFF11998E), Color(0xFF38EF7D)];
      case 'Lights':
        return [Color(0xFFFFB347), Color(0xFFFFCC33)];
      case 'Tools':
        return [Color(0xFFB621FE), Color(0xFF1FD1F9)];
      default:
        return [Color(0xFF667EEA), Color(0xFF764BA2)];
    }
  }

  void _handleItemAction(String action, Map<String, dynamic> item) {
    switch (action) {
      case 'details':
        _navigateToItemDetails(context, item);
        break;
      case 'edit':
        _navigateToEditItem(context, item);
        break;
      case 'delete':
        _showDeleteDialog(item);
        break;
    }
  }

  void _navigateToAddItem(BuildContext context) {
    Navigator.pushNamed(context, '/inventory/add');
  }

  void _navigateToItemDetails(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/inventory/details',
      arguments: item,
    );
  }

  void _navigateToEditItem(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/inventory/edit',
      arguments: item,
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Delete Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${item['name']}"? This action cannot be undone.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Implement delete functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('${item['name']} deleted successfully'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}