// features/search/search_screen.dart
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear),
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
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All Categories'),
                    ),
                    DropdownMenuItem(
                      value: 'items',
                      child: Text('Items'),
                    ),
                    DropdownMenuItem(
                      value: 'customers',
                      child: Text('Customers'),
                    ),
                    DropdownMenuItem(
                      value: 'sales',
                      child: Text('Sales'),
                    ),
                    DropdownMenuItem(
                      value: 'purchases',
                      child: Text('Purchases'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return Center(
        child: Text('Enter search terms to find items'),
      );
    }

    // In a real app, you would query the database based on search criteria
    // Here we just show dummy data based on the selected category
    switch (_selectedCategory) {
      case 'items':
        return _buildItemResults();
      case 'customers':
        return _buildCustomerResults();
      case 'sales':
        return _buildSaleResults();
      case 'purchases':
        return _buildPurchaseResults();
      default:
        return _buildAllResults();
    }
  }

  Widget _buildItemResults() {
    // Dummy data - replace with actual database query
    final dummyItems = List.generate(5, (index) {
      return {
        'id': index + 1,
        'name': 'Item ${index + 1} ${_searchQuery}',
        'category': ['Wires', 'Switches', 'Lights', 'Tools'][index % 4],
        'quantity': 100 + index * 5,
      };
    });

    return ListView.builder(
      itemCount: dummyItems.length,
      itemBuilder: (context, index) {
        final item = dummyItems[index];
        return ListTile(
          leading: Icon(Icons.inventory),
          title: Text(item['name'].toString()),
          subtitle: Text('Category: ${item['category']}'),
          trailing: Text('Qty: ${item['quantity']}'),
          onTap: () => _navigateToItemDetails(context, item),
        );
      },
    );
  }

  Widget _buildCustomerResults() {
    // Similar implementation for customers
    return Center(child: Text('Customer results for "$_searchQuery"'));
  }

  Widget _buildSaleResults() {
    // Similar implementation for sales
    return Center(child: Text('Sale results for "$_searchQuery"'));
  }

  Widget _buildPurchaseResults() {
    // Similar implementation for purchases
    return Center(child: Text('Purchase results for "$_searchQuery"'));
  }

  Widget _buildAllResults() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Items'),
              Tab(text: 'Customers'),
              Tab(text: 'Sales'),
              Tab(text: 'Purchases'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildItemResults(),
                _buildCustomerResults(),
                _buildSaleResults(),
                _buildPurchaseResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToItemDetails(BuildContext context, Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/inventory/details',
      arguments: item,
    );
  }
}