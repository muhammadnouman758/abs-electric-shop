// features/inventory/item_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemEditScreen extends StatefulWidget {
  final Map<String, dynamic>? item;

  ItemEditScreen({this.item});

  @override
  _ItemEditScreenState createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _quantityController;
  late TextEditingController _minStockController;
  late TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?['name'] ?? '');
    _descriptionController = TextEditingController(text: item?['description'] ?? '');
    _categoryController = TextEditingController(text: item?['category'] ?? '');
    _purchasePriceController = TextEditingController(
        text: item?['purchase_price']?.toString() ?? '');
    _salePriceController = TextEditingController(
        text: item?['sale_price']?.toString() ?? '');
    _quantityController = TextEditingController(
        text: item?['quantity']?.toString() ?? '');
    _minStockController = TextEditingController(
        text: item?['min_stock_level']?.toString() ?? '');
    _barcodeController = TextEditingController(text: item?['barcode'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveItem,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Item Name', isRequired: true),
              _buildTextField(_descriptionController, 'Description'),
              _buildTextField(_categoryController, 'Category'),
              _buildNumberField(_purchasePriceController, 'Purchase Price',
                  isRequired: true),
              _buildNumberField(_salePriceController, 'Sale Price',
                  isRequired: true),
              _buildNumberField(_quantityController, 'Quantity',
                  isRequired: true, isInteger: true),
              _buildNumberField(_minStockController, 'Minimum Stock Level',
                  isInteger: true),
              _buildTextField(_barcodeController, 'Barcode/Serial Number'),
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
      {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? ' *' : ''),
          border: OutlineInputBorder(),
        ),
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

  Widget _buildNumberField(
      TextEditingController controller, String labelText,
      {bool isRequired = false, bool isInteger = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? ' *' : ''),
          border: OutlineInputBorder(),
        ),
        keyboardType:
        TextInputType.numberWithOptions(decimal: !isInteger),
        inputFormatters: [
          isInteger
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
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
        onPressed: _saveItem,
        child: Text(
          'SAVE ITEM',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'purchase_price': double.parse(_purchasePriceController.text),
        'sale_price': double.parse(_salePriceController.text),
        'quantity': int.parse(_quantityController.text),
        'min_stock_level': _minStockController.text.isNotEmpty
            ? int.parse(_minStockController.text)
            : null,
        'barcode': _barcodeController.text,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (widget.item != null) {
        // Update existing item
        newItem['id'] = widget.item!['id'];
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item updated successfully')),
        );
      } else {
        // Add new item
        newItem['created_at'] = DateTime.now().toIso8601String();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added successfully')),
        );
      }

      // Save to database and navigate back
      Navigator.pop(context, newItem);
    }
  }
}