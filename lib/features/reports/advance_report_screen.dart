// features/reports/advanced_report_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdvancedReportScreen extends StatefulWidget {
  @override
  _AdvancedReportScreenState createState() => _AdvancedReportScreenState();
}

class _AdvancedReportScreenState extends State<AdvancedReportScreen> {
  String _reportType = 'sales';
  DateTimeRange? _dateRange;
  String _categoryFilter = '';
  String _paymentMethodFilter = '';
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReportTypeSelector(),
            SizedBox(height: 16),
            _buildDateRangeSelector(),
            SizedBox(height: 16),
            _buildAdditionalFilters(),
            SizedBox(height: 24),
            _buildReportVisualization(),
            SizedBox(height: 24),
            _buildReportDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _reportType,
              items: [
                DropdownMenuItem(
                  value: 'sales',
                  child: Text('Sales Report'),
                ),
                DropdownMenuItem(
                  value: 'purchases',
                  child: Text('Purchases Report'),
                ),
                DropdownMenuItem(
                  value: 'profit',
                  child: Text('Profit Analysis'),
                ),
                DropdownMenuItem(
                  value: 'inventory',
                  child: Text('Inventory Movement'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _reportType = value;
                    _categoryFilter = '';
                    _paymentMethodFilter = '';
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _dateRange == null
                          ? 'Select Date Range'
                          : '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}',
                    ),
                    Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Filters',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            if (_reportType == 'sales' || _reportType == 'profit')
              _buildFilterDropdown(
                'Payment Method',
                _paymentMethodFilter,
                ['All', 'Cash', 'Card', 'UPI', 'Bank Transfer'],
                    (value) => setState(() => _paymentMethodFilter = value == 'All' ? '' : value!),
              ),
            if (_reportType != 'profit')
              _buildFilterDropdown(
                'Category',
                _categoryFilter,
                ['All', 'Wires', 'Switches', 'Lights', 'Tools', 'Accessories'],
                    (value) => setState(() => _categoryFilter = value == 'All' ? '' : value!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
      String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? 'All' : value,
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildReportVisualization() {
    // Dummy data based on report type
    final chartData = _generateChartData();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _getReportTitle(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Container(
            //   height: 300,
            //   child: SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     series: _getChartSeries(chartData),
            //     tooltipBehavior: TooltipBehavior(enable: true),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportDataTable() {
    // Dummy data based on report type
    final tableData = _generateTableData();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Detailed Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _getDataTableColumns(),
                rows: tableData
                    .map((data) => DataRow(
                  cells: _getDataTableCells(data),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  void _exportReport() {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report exported successfully')),
    );
  }

  // Helper methods to generate report-specific data
  List<Map<String, dynamic>> _generateChartData() {
    switch (_reportType) {
      case 'sales':
        return [
          {'month': 'Jan', 'sales': 4500, 'items': 120},
          {'month': 'Feb', 'sales': 5200, 'items': 135},
          {'month': 'Mar', 'sales': 4800, 'items': 125},
          {'month': 'Apr', 'sales': 6100, 'items': 150},
          {'month': 'May', 'sales': 5700, 'items': 140},
          {'month': 'Jun', 'sales': 6300, 'items': 160},
        ];
      case 'purchases':
        return [
          {'month': 'Jan', 'purchases': 3200, 'items': 80},
          {'month': 'Feb', 'purchases': 3800, 'items': 95},
          {'month': 'Mar', 'purchases': 3500, 'items': 85},
          {'month': 'Apr', 'purchases': 4200, 'items': 110},
          {'month': 'May', 'purchases': 3900, 'items': 100},
          {'month': 'Jun', 'purchases': 4500, 'items': 120},
        ];
      case 'profit':
        return [
          {'month': 'Jan', 'revenue': 4500, 'cost': 3200, 'profit': 1300},
          {'month': 'Feb', 'revenue': 5200, 'cost': 3800, 'profit': 1400},
          {'month': 'Mar', 'revenue': 4800, 'cost': 3500, 'profit': 1300},
          {'month': 'Apr', 'revenue': 6100, 'cost': 4200, 'profit': 1900},
          {'month': 'May', 'revenue': 5700, 'cost': 3900, 'profit': 1800},
          {'month': 'Jun', 'revenue': 6300, 'cost': 4500, 'profit': 1800},
        ];
      case 'inventory':
        return [
          {'month': 'Jan', 'in': 150, 'out': 120, 'stock': 500},
          {'month': 'Feb', 'in': 180, 'out': 135, 'stock': 545},
          {'month': 'Mar', 'in': 160, 'out': 125, 'stock': 580},
          {'month': 'Apr', 'in': 200, 'out': 150, 'stock': 630},
          {'month': 'May', 'in': 190, 'out': 140, 'stock': 680},
          {'month': 'Jun', 'in': 220, 'out': 160, 'stock': 740},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _generateTableData() {
    switch (_reportType) {
      case 'sales':
        return List.generate(10, (index) {
          return {
            'date': DateTime.now().subtract(Duration(days: index)),
            'invoice': 'INV-${1000 + index}',
            'customer': 'Customer ${index + 1}',
            'amount': 150.0 + index * 25,
            'payment': ['Cash', 'Card', 'UPI'][index % 3],
            'items': 2 + index % 4,
          };
        });
      case 'purchases':
        return List.generate(10, (index) {
          return {
            'date': DateTime.now().subtract(Duration(days: index)),
            'invoice': 'PUR-${2000 + index}',
            'supplier': 'Supplier ${index % 3 + 1}',
            'amount': 350.0 + index * 30,
            'items': 3 + index % 5,
          };
        });
      case 'profit':
        return List.generate(10, (index) {
          return {
            'date': DateTime.now().subtract(Duration(days: index)),
            'type': ['Sale', 'Purchase', 'Expense'][index % 3],
            'reference': index % 3 == 0 ? 'INV-${1000 + index}' : 'EXP-${500 + index}',
            'amount': index % 3 == 0 ? 150.0 + index * 25 : -(50.0 + index * 10),
          };
        });
      case 'inventory':
        return List.generate(10, (index) {
          return {
            'date': DateTime.now().subtract(Duration(days: index)),
            'item': 'Item ${index + 1}',
            'category': ['Wires', 'Switches', 'Lights', 'Tools'][index % 4],
            'in': 10 + index,
            'out': 5 + index,
            'stock': 100 + index * 5,
          };
        });
      default:
        return [];
    }
  }

  String _getReportTitle() {
    switch (_reportType) {
      case 'sales':
        return 'Sales Performance';
      case 'purchases':
        return 'Purchases Overview';
      case 'profit':
        return 'Profit Analysis';
      case 'inventory':
        return 'Inventory Movement';
      default:
        return 'Report';
    }
  }

  List<ChartSeries> _getChartSeries(List<Map<String, dynamic>> data) {
    switch (_reportType) {
      case 'sales':
        return [
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['sales'],
            name: 'Sales',
            color: Colors.blue,
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['items'],
            name: 'Items Sold',
            color: Colors.green,
          ),
        ];
      case 'purchases':
        return [
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['purchases'],
            name: 'Purchases',
            color: Colors.orange,
          ),
        ];
      case 'profit':
        return [
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['revenue'],
            name: 'Revenue',
            color: Colors.green,
          ),
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['cost'],
            name: 'Cost',
            color: Colors.red,
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['profit'],
            name: 'Profit',
            color: Colors.blue,
          ),
        ];
      case 'inventory':
        return [
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['in'],
            name: 'In',
            color: Colors.green,
          ),
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['out'],
            name: 'Out',
            color: Colors.red,
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (data, _) => data['month'],
            yValueMapper: (data, _) => data['stock'],
            name: 'Stock',
            color: Colors.blue,
          ),
        ];
      default:
        return [];
    }
  }

  List<DataColumn> _getDataTableColumns() {
    switch (_reportType) {
      case 'sales':
        return [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Invoice')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Payment')),
          DataColumn(label: Text('Items')),
        ];
      case 'purchases':
        return [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Invoice')),
          DataColumn(label: Text('Supplier')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Items')),
        ];
      case 'profit':
        return [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Reference')),
          DataColumn(label: Text('Amount')),
        ];
      case 'inventory':
        return [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Item')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('In')),
          DataColumn(label: Text('Out')),
          DataColumn(label: Text('Stock')),
        ];
      default:
        return [];
    }
  }

  List<DataCell> _getDataTableCells(Map<String, dynamic> data) {
    switch (_reportType) {
      case 'sales':
        return [
          DataCell(Text(_dateFormat.format(data['date']))),
          DataCell(Text(data['invoice'])),
          DataCell(Text(data['customer'])),
          DataCell(Text('\$${data['amount'].toStringAsFixed(2)}')),
          DataCell(Text(data['payment'])),
          DataCell(Text(data['items'].toString())),
        ];
      case 'purchases':
        return [
          DataCell(Text(_dateFormat.format(data['date']))),
          DataCell(Text(data['invoice'])),
          DataCell(Text(data['supplier'])),
          DataCell(Text('\$${data['amount'].toStringAsFixed(2)}')),
          DataCell(Text(data['items'].toString())),
        ];
      case 'profit':
        return [
          DataCell(Text(_dateFormat.format(data['date']))),
          DataCell(Text(data['type'])),
          DataCell(Text(data['reference'])),
          DataCell(Text(
            '\$${data['amount'].toStringAsFixed(2)}',
            style: TextStyle(
              color: data['amount'] >= 0 ? Colors.green : Colors.red,
            ),
          )),
        ];
      case 'inventory':
        return [
          DataCell(Text(_dateFormat.format(data['date']))),
          DataCell(Text(data['item'])),
          DataCell(Text(data['category'])),
          DataCell(Text(data['in'].toString())),
          DataCell(Text(data['out'].toString())),
          DataCell(Text(data['stock'].toString())),
        ];
      default:
        return [];
    }
  }
}