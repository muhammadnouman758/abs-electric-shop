// admin_panel/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.settings, size: 20),
              ),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 24),
            _buildSummaryCards(context),
            SizedBox(height: 24),
            _buildQuickActions(context),
            SizedBox(height: 24),
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
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
                  'Welcome back, Admin!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening with your store today.',
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 215,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 36, color: Color(0xFF667EEA)),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Admin User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'admin@electricstore.com',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            _buildDrawerItem(
              context,
              Icons.dashboard_rounded,
              'Dashboard',
                  () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/admin');
              },
              isSelected: true,
            ),
            _buildDrawerItem(
              context,
              Icons.inventory_2_rounded,
              'Inventory',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inventory');
              },
            ),
            _buildDrawerItem(
              context,
              Icons.shopping_cart_rounded,
              'Purchases',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/purchases');
              },
            ),
            _buildDrawerItem(
              context,
              Icons.point_of_sale_rounded,
              'Sales',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sales');
              },
            ),
            _buildDrawerItem(
              context,
              Icons.analytics_rounded,
              'Reports',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reports');
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(),
            ),
            _buildDrawerItem(
              context,
              Icons.settings_rounded,
              'Settings',
                  () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _buildDrawerItem(
              context,
              Icons.logout_rounded,
              'Logout',
                  () {
                // Handle logout
                Navigator.popUntil(context, ModalRoute.withName('/auth'));
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool isSelected = false,
        bool isLogout = false,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFF667EEA).withOpacity(0.1)
                : isLogout
                ? Colors.red.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Color(0xFF667EEA)
                : isLogout
                ? Colors.red
                : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Color(0xFF667EEA)
                : isLogout
                ? Colors.red
                : Colors.grey[800],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isSelected ? Color(0xFF667EEA).withOpacity(0.05) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1, // Increased from 1.3 to give more height
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _summaryCard(
          context,
          'Total Stock',
          '1,245',
          Icons.inventory_2_rounded,
          [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        _summaryCard(
          context,
          'Today\'s Sales',
          '\$2,450',
          Icons.attach_money_rounded,
          [Color(0xFF11998E), Color(0xFF38EF7D)],
        ),
        _summaryCard(
          context,
          'Monthly Profit',
          '\$12,500',
          Icons.trending_up_rounded,
          [Color(0xFFB621FE), Color(0xFF1FD1F9)],
        ),
        _summaryCard(
          context,
          'Low Stock',
          '15 Items',
          Icons.warning_rounded,
          [Color(0xFFFFB347), Color(0xFFFFCC33)],
        ),
      ],
    );
  }

  Widget _summaryCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      List<Color> gradientColors,
      ) {
    return Container(

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
        padding: EdgeInsets.all(16), // Reduced from 20 to 16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed from default to spaceBetween
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13, // Reduced from 14
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8), // Reduced from 10
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18), // Reduced from 20
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22, // Reduced from 24
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8), // Added space between value and button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors.map((c) => c.withOpacity(0.1)).toList(),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: gradientColors[0],
                      fontWeight: FontWeight.w600,
                      fontSize: 11, // Reduced from 12
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bolt, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _quickActionButton(
                  context,
                  'Add Item',
                  Icons.add_circle_outline_rounded,
                  [Color(0xFF667EEA), Color(0xFF764BA2)],
                      () => Navigator.pushNamed(context, '/inventory/add'),
                ),
                _quickActionButton(
                  context,
                  'New Sale',
                  Icons.point_of_sale_rounded,
                  [Color(0xFF11998E), Color(0xFF38EF7D)],
                      () => Navigator.pushNamed(context, '/sales/new'),
                ),
                _quickActionButton(
                  context,
                  'New Purchase',
                  Icons.shopping_cart_checkout_rounded,
                  [Color(0xFFB621FE), Color(0xFF1FD1F9)],
                      () => Navigator.pushNamed(context, '/purchases/new'),
                ),
                _quickActionButton(
                  context,
                  'Generate Report',
                  Icons.analytics_rounded,
                  [Color(0xFFFFB347), Color(0xFFFFCC33)],
                      () => Navigator.pushNamed(context, '/reports/generate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionButton(
      BuildContext context,
      String label,
      IconData icon,
      List<Color> gradientColors,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors.map((c) => c.withOpacity(0.1)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gradientColors[0].withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: gradientColors[0],
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: gradientColors[0],
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.history, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => Divider(
                height: 24,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                // Replace with actual recent activity data
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.point_of_sale, color: Colors.white, size: 16),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sale #${1000 + index}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              '2 hours ago',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF11998E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${150 + index * 25}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF11998E),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}