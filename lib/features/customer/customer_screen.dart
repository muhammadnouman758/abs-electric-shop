// features/customers/customers_screen.dart
import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddCustomer(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Customers',
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
          ),
          Expanded(
            child: _buildCustomersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddCustomer(context),
      ),
    );
  }

  Widget _buildCustomersList() {
    // Replace with actual data from database
    List<Map<String, dynamic>> dummyCustomers = List.generate(20, (index) {
      return {
        'id': index + 1,
        'name': 'Customer ${index + 1}',
        'phone': '+91 ${9000000000 + index}',
        'email': 'customer${index + 1}@example.com',
        'address': 'Address ${index + 1}, City',
        'total_purchases': 1000 + index * 500,
        'last_purchase': DateTime.now().subtract(Duration(days: index)),
      };
    });

    // Filter customers based on search query
    final filteredCustomers = dummyCustomers.where((customer) {
      final name = customer['name'].toString().toLowerCase();
      final phone = customer['phone'].toString().toLowerCase();
      final email = customer['email'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          phone.contains(query) ||
          email.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = filteredCustomers[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(customer['name'][0]),
            ),
            title: Text(customer['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer['phone']),
                Text('Total Purchases: \$${customer['total_purchases']}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.history),
              onPressed: () => _viewPurchaseHistory(context, customer),
            ),
            onTap: () => _navigateToCustomerDetails(context, customer),
          ),
        );
      },
    );
  }

  void _navigateToAddCustomer(BuildContext context) {
    Navigator.pushNamed(context, '/customers/add');
  }

  void _navigateToCustomerDetails(
      BuildContext context, Map<String, dynamic> customer) {
    Navigator.pushNamed(
      context,
      '/customers/details',
      arguments: customer,
    );
  }

  void _viewPurchaseHistory(BuildContext context, Map<String, dynamic> customer) {
    Navigator.pushNamed(
      context,
      '/customers/history',
      arguments: customer['id'],
    );
  }
}

// Customer Edit/Add Screen
class CustomerEditScreen extends StatefulWidget {
  final Map<String, dynamic>? customer;

  CustomerEditScreen({this.customer});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?['name'] ?? '');
    _phoneController = TextEditingController(text: customer?['phone'] ?? '');
    _emailController = TextEditingController(text: customer?['email'] ?? '');
    _addressController = TextEditingController(text: customer?['address'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveCustomer,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name', isRequired: true),
              _buildTextField(_phoneController, 'Phone', isRequired: true),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_addressController, 'Address', maxLines: 3),
              SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText,
      {bool isRequired = false, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? ' *' : ''),
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        }
            : null,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _saveCustomer,
        child: Text(
          'SAVE CUSTOMER',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final newCustomer = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (widget.customer != null) {
        // Update existing customer
        newCustomer['id'] = widget.customer!['id'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer updated successfully')),
        );
      } else {
        // Add new customer
        newCustomer['created_at'] = DateTime.now().toIso8601String();
        newCustomer['total_purchases'] = '0';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer added successfully')),
        );
      }

      // Save to database and navigate back
      Navigator.pop(context, newCustomer);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}