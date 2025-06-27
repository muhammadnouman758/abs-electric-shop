// features/auth/role_management.dart
import 'package:flutter/material.dart';

class RoleManagementScreen extends StatefulWidget {
  @override
  _RoleManagementScreenState createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _roles = [
    {'id': 1, 'name': 'Admin', 'permissions': 'all'},
    {'id': 2, 'name': 'Manager', 'permissions': 'inventory,sales,reports'},
    {'id': 3, 'name': 'Sales', 'permissions': 'sales'},
    {'id': 4, 'name': 'Inventory', 'permissions': 'inventory'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // Replace with actual database query
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _users = [
        {
          'id': 1,
          'name': 'Admin User',
          'email': 'admin@store.com',
          'role_id': 1,
          'status': 'active',
        },
        {
          'id': 2,
          'name': 'Sales Manager',
          'email': 'manager@store.com',
          'role_id': 2,
          'status': 'active',
        },
        {
          'id': 3,
          'name': 'Sales Staff',
          'email': 'sales@store.com',
          'role_id': 3,
          'status': 'active',
        },
        {
          'id': 4,
          'name': 'Inventory Staff',
          'email': 'inventory@store.com',
          'role_id': 4,
          'status': 'inactive',
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Roles Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewUser,
          ),
        ],
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          final role = _roles.firstWhere(
                  (role) => role['id'] == user['role_id']);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user['name'][0]),
              ),
              title: Text(user['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['email']),
                  Text('Role: ${role['name']}'),
                  Text('Status: ${user['status']}'),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Edit Role'),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Text(user['status'] == 'active'
                        ? 'Deactivate'
                        : 'Activate'),
                    value: 'toggle',
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 'delete',
                  ),
                ],
                onSelected: (value) => _handleUserAction(value, user),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _editUserRole(user);
        break;
      case 'toggle':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
    }
  }

  void _editUserRole(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Role for ${user['name']}'),
        content: DropdownButtonFormField<int>(
          value: user['role_id'],
          items: _roles.map<DropdownMenuItem<int>>((role) {
            return DropdownMenuItem<int>(
              value: role['id'] as int,
              child: Text(role['name']),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                user['role_id'] = value;
              });
              // Update in database
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Role updated successfully')),
              );
            }
          },
          decoration: const InputDecoration(
            labelText: 'Select Role',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['status'] = user['status'] == 'active' ? 'inactive' : 'active';
    });
    // Update in database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User status updated')),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user['name']}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              // Delete from database
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User deleted successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addNewUser() {
    // Implement add new user functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add new user functionality')),
    );
  }
}