import 'package:electric_store/admin_panel/admin_dashboard.dart';
import 'package:electric_store/features/auth/auth_screen.dart';
import 'package:electric_store/features/inventory/inventory_ui.dart';
import 'package:electric_store/features/inventory/item_edit_screen.dart';
import 'package:electric_store/features/purchase/purchase_screen.dart';
import 'package:electric_store/features/reports/report_screen.dart';
import 'package:electric_store/features/sale/sale_screen.dart';
import 'package:electric_store/features/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/service_notification.dart';
import 'features/app_settings/theme_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.currentTheme,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/auth' : (context) => AuthScreen(),
        '/admin' : (context) => AdminDashboard(),
        '/inventory' : (context) => InventoryScreen(),
        '/purchases' : (context) => PurchasesScreen(),
        '/sales' : (context) => SalesScreen(),
        '/reports' : (context) => ReportsScreen(),
        '/inventory/edit' : (context) => ItemEditScreen(),
        // '/inventory/add' : (context) => ItemEditScreen(),

      },
    );
  }
}
