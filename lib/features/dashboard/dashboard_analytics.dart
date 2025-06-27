import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsDashboard extends StatefulWidget {
  @override
  _AnalyticsDashboardState createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String _timeRange = 'monthly'; // weekly, monthly, yearly
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _selectTimeRange,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimeRangeSelector(),
            SizedBox(height: 20),
            _buildSummaryCards(),
            SizedBox(height: 20),
            _buildSalesChart(),
            SizedBox(height: 20),
            _buildInventoryChart(),
            SizedBox(height: 20),
            _buildTopProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _timeRangeButton('Weekly', 'weekly'),
        _timeRangeButton('Monthly', 'monthly'),
        _timeRangeButton('Yearly', 'yearly'),
      ],
    );
  }

  Widget _timeRangeButton(String label, String value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _timeRange == value ? Theme.of(context).primaryColor : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _timeRange = value;
          _updateDateRange();
        });
      },
      child: Text(label),
    );
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_timeRange) {
      case 'weekly':
        setState(() {
          _dateRange = DateTimeRange(
            start: now.subtract(Duration(days: 7)),
            end: now,
          );
        });
        break;
      case 'monthly':
        setState(() {
          _dateRange = DateTimeRange(
            start: now.subtract(Duration(days: 30)),
            end: now,
          );
        });
        break;
      case 'yearly':
        setState(() {
          _dateRange = DateTimeRange(
            start: DateTime(now.year, 1, 1),
            end: now,
          );
        });
        break;
    }
  }

  Future<void> _selectTimeRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
        _timeRange = 'custom';
      });
    }
  }

  Widget _buildSummaryCards() {
    // Replace with actual data
    final salesData = {
      'total': 12500.0,
      'change': 12.5,
      'trend': 'up',
    };
    final profitData = {
      'total': 4500.0,
      'change': 8.2,
      'trend': 'up',
    };
    final inventoryData = {
      'total': 1245,
      'change': -3.2,
      'trend': 'down',
    };

    return Row(
      children: [
        Expanded(child: _summaryCard('Sales', salesData, Colors.blue)),
        Expanded(child: _summaryCard('Profit', profitData, Colors.green)),
        Expanded(child: _summaryCard('Inventory', inventoryData, Colors.orange)),
      ],
    );
  }

  Widget _summaryCard(String title, Map<String, dynamic> data, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$${data['total'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  data['trend'] == 'up' ? Icons.trending_up : Icons.trending_down,
                  color: data['trend'] == 'up' ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  '${data['change']}%',
                  style: TextStyle(
                    color: data['trend'] == 'up' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    // Replace with actual data from database
    final salesData = _generateSalesData();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Performance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Container(
            //   height: 250,
            //   child: SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     series: <ChartSeries<Map<String, dynamic>, String>>[
            //       LineSeries<Map<String, dynamic>, String>(
            //         dataSource: salesData,
            //         xValueMapper: (Map<String, dynamic> data, _) => data['period'] as String,
            //         yValueMapper: (Map<String, dynamic> data, _) => data['sales'] as num,
            //         name: 'Sales',
            //         color: Colors.blue,
            //         markerSettings: const MarkerSettings(isVisible: true),
            //       ),
            //     ],
            //     tooltipBehavior: TooltipBehavior(enable: true),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateSalesData() {
    if (_timeRange == 'weekly') {
      return List.generate(7, (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        return {
          'period': DateFormat('EEE').format(date),
          'sales': 500 + (index * 200).toDouble(),
        };
      });
    } else if (_timeRange == 'monthly') {
      return List.generate(4, (index) {
        return {
          'period': 'Week ${index + 1}',
          'sales': 1000 + (index * 500).toDouble(),
        };
      });
    } else {
      return List.generate(12, (index) {
        return {
          'period': DateFormat('MMM').format(DateTime(DateTime.now().year, index + 1)),
          'sales': 2000 + (index * 400).toDouble(),
        };
      });
    }
  }

  Widget _buildInventoryChart() {
    // Replace with actual data from database
    final inventoryData = _generateInventoryData();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Levels',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Container(
            //   height: 250,
            //   child: SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     series: <ChartSeries>[
            //       ColumnSeries<Map<String, dynamic>, String>(
            //         dataSource: inventoryData,
            //         xValueMapper: (data, _) => data['category'],
            //         yValueMapper: (data, _) => data['count'],
            //         name: 'Inventory',
            //         color: Colors.orange,
            //       ),
            //     ],
            //     tooltipBehavior: TooltipBehavior(enable: true),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateInventoryData() {
    return [
      {'category': 'Wires', 'count': 320},
      {'category': 'Switches', 'count': 180},
      {'category': 'Lights', 'count': 420},
      {'category': 'Tools', 'count': 150},
      {'category': 'Accessories', 'count': 175},
    ];
  }

  Widget _buildTopProducts() {
    // Replace with actual data from database
    final topProducts = _generateTopProducts();

    return Card(
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
          TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Product',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Sold',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Revenue',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
          decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),

    )
          ),...topProducts.map((product) {
    return TableRow(
    decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
    children: [
    Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(product['name']),
    ),
    Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
    product['sold'].toString(),
    textAlign: TextAlign.center,
    ),
    ),
    Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
    '\$${product['revenue'].toStringAsFixed(2)}',
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

  List<Map<String, dynamic>> _generateTopProducts() {
    return [
      {'name': 'Copper Wire 2.5mm', 'sold': 45, 'revenue': 2250.0},
      {'name': 'LED Bulb 9W', 'sold': 38, 'revenue': 1900.0},
      {'name': 'Switch Socket', 'sold': 32, 'revenue': 1600.0},
      {'name': 'Circuit Breaker', 'sold': 28, 'revenue': 1400.0},
      {'name': 'Electrical Tape', 'sold': 25, 'revenue': 1250.0},
    ];
  }
}