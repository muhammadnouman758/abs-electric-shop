// features/reports/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with TickerProviderStateMixin {
  String _selectedReportType = 'sales';
  DateTimeRange? _dateRange;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        title: Text(
          'Reports & Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.file_download, color: Colors.blue[600], size: 20),
              ),
              onPressed: _exportReport,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.share, color: Colors.green[600], size: 20),
              ),
              onPressed: _shareReport,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 24),
              _buildReportTypeSelector(),
              SizedBox(height: 20),
              _buildDateRangeSelector(),
              SizedBox(height: 32),
              _buildReportContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Intelligence',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your performance with detailed insights',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.analytics,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assessment, color: Colors.grey[600], size: 20),
              SizedBox(width: 8),
              Text(
                'Report Type',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3,
            children: [
              _reportTypeCard('Sales', 'sales', Icons.trending_up, Colors.green),
              _reportTypeCard('Purchases', 'purchases', Icons.shopping_cart, Colors.orange),
              _reportTypeCard('Inventory', 'inventory', Icons.inventory, Colors.purple),
              _reportTypeCard('Profit/Loss', 'profit_loss', Icons.account_balance, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportTypeCard(String label, String value, IconData icon, Color color) {
    bool isSelected = _selectedReportType == value;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedReportType = value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey[600],
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range, color: Colors.grey[600], size: 20),
              SizedBox(width: 8),
              Text(
                'Date Range',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDateRange(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _dateRange == null
                                ? 'Select Date Range'
                                : '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}',
                            style: TextStyle(
                              color: _dateRange == null ? Colors.grey[500] : Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _dateRange == null ? null : _generateReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _dateRange == null ? Colors.grey[300] : Colors.blue[600],
                    foregroundColor: Colors.white,
                    elevation: _dateRange == null ? 0 : 4,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_graph, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Generate',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _getReportWidget(),
    );
  }

  Widget _getReportWidget() {
    switch (_selectedReportType) {
      case 'sales':
        return _buildSalesReport();
      case 'purchases':
        return _buildPurchasesReport();
      case 'inventory':
        return _buildInventoryReport();
      case 'profit_loss':
        return _buildProfitLossReport();
      default:
        return _buildEmptyState();
    }
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        SizedBox(height: 40),
        Icon(
          Icons.analytics_outlined,
          size: 64,
          color: Colors.grey[400],
        ),
        SizedBox(height: 16),
        Text(
          'Select Report Parameters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose a report type and date range to generate insights',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSalesReport() {
    // Dummy sales data
    final salesData = [
      {'month': 'Jan', 'sales': 4500},
      {'month': 'Feb', 'sales': 5200},
      {'month': 'Mar', 'sales': 4800},
      {'month': 'Apr', 'sales': 6100},
      {'month': 'May', 'sales': 5700},
      {'month': 'Jun', 'sales': 6300},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.trending_up, color: Colors.green[600], size: 24),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Report',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Revenue performance overview',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 24),

        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Sales',
                '\$32,600',
                Icons.attach_money,
                Colors.green,
                '+12.5%',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Avg Monthly',
                '\$5,433',
                Icons.calendar_month,
                Colors.blue,
                '+8.2%',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Data Table with modern styling
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              dataRowHeight: 56,
              columns: [
                DataColumn(
                  label: Text('Month'),
                ),
                DataColumn(
                  label: Text('Sales Amount'),
                ),
              ],
              rows: salesData
                  .map((data) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      data['month'].toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${data['sales']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                ],
              ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              Spacer(),
              Text(
                change,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesReport() {
    return _buildPlaceholderReport(
      'Purchases Report',
      'Track your procurement expenses',
      Icons.shopping_cart,
      Colors.orange,
    );
  }

  Widget _buildInventoryReport() {
    return _buildPlaceholderReport(
      'Inventory Report',
      'Monitor your stock levels',
      Icons.inventory,
      Colors.purple,
    );
  }

  Widget _buildProfitLossReport() {
    return _buildPlaceholderReport(
      'Profit/Loss Report',
      'Analyze your financial performance',
      Icons.account_balance,
      Colors.blue,
    );
  }

  Widget _buildPlaceholderReport(String title, String subtitle, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 40),
        Icon(
          Icons.construction,
          size: 48,
          color: Colors.grey[400],
        ),
        SizedBox(height: 16),
        Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This report is under development',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 40),
      ],
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

  void _generateReport() {
    // Implement report generation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Report generated for selected date range'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    setState(() {});
  }

  void _exportReport() async {
    // Implement export to CSV/Excel functionality
    // Using packages like excel or csv
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_done, color: Colors.white),
            SizedBox(width: 8),
            Text('Report exported successfully'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareReport() async {
    // Implement share functionality using share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.share, color: Colors.white),
            SizedBox(width: 8),
            Text('Sharing report...'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}