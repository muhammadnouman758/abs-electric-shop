//
//
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:googleapis/drive/v3.dart' ;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sqflite/sqflite.dart' ;
//
// import '../../core/database/database_helper.dart';
//
// class DataBackupScreen extends StatefulWidget {
//   @override
//   _DataBackupScreenState createState() => _DataBackupScreenState();
// }
//
// class _DataBackupScreenState extends State<DataBackupScreen> {
//   bool _isBackingUp = false;
//   bool _isRestoring = false;
//   String _backupStatus = '';
//   String _restoreStatus = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Backup & Restore'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Backup Database',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Create a backup of all your data to a file',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _isBackingUp ? null : _createBackup,
//                       child: _isBackingUp
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('CREATE BACKUP'),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       _backupStatus,
//                       style: TextStyle(
//                         color: _backupStatus.contains('Failed')
//                             ? Colors.red
//                             : Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Restore Database',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Restore your data from a backup file',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _isRestoring ? null : _restoreBackup,
//                       child: _isRestoring
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('RESTORE BACKUP'),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       _restoreStatus,
//                       style: TextStyle(
//                         color: _restoreStatus.contains('Failed')
//                             ? Colors.red
//                             : Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _createBackup() async {
//     setState(() {
//       _isBackingUp = true;
//       _backupStatus = '';
//     });
//
//     try {
//       // Request storage permission
//       final status = await Permission;
//       if (!status.isGranted) {
//         throw Exception('Storage permission denied');
//       }
//
//       // Get database file path
//       final databasesPath = await getDatabasesPath();
//       final dbPath = '$databasesPath/electric_store.db';
//
//       // Let user choose where to save the backup
//       final String? savePath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save Backup As',
//         fileName: 'electric_store_backup_${DateTime.now().millisecondsSinceEpoch}.db',
//         type: FileType.any,
//       );
//
//       if (savePath == null) {
//         throw Exception('No location selected');
//       }
//
//       // Copy database file to backup location
//       final dbFile = File(dbPath);
//       await dbFile.copy(savePath);
//
//       setState(() {
//         _backupStatus = 'Backup created successfully at $savePath';
//       });
//     } catch (e) {
//       setState(() {
//         _backupStatus = 'Backup failed: $e';
//       });
//     } finally {
//       setState(() => _isBackingUp = false);
//     }
//   }
//
//   Future<void> _restoreBackup() async {
//     setState(() {
//       _isRestoring = true;
//       _restoreStatus = '';
//     });
//
//     try {
//       // Request storage permission
//       final status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw Exception('Storage permission denied');
//       }
//
//       // Let user select backup file
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.any,
//         allowMultiple: false,
//       );
//
//       if (result == null || result.files.isEmpty) {
//         throw Exception('No file selected');
//       }
//
//       final backupFile = File(result.files.single.path!);
//       if (!backupFile.existsSync()) {
//         throw Exception('Backup file not found');
//       }
//       final databasesPath = await getDatabasesPath();
//       final dbPath = '$databasesPath/electric_store.db';
//       final dbFile = File(dbPath);
//       if (dbFile.existsSync()) {
//         await dbFile.delete();
//       }
//       await backupFile.copy(dbPath);
//
//       // Reopen database
//       await DatabaseHelper.instance.database;
//
//       setState(() {
//         _restoreStatus = 'Database restored successfully';
//       });
//
//       // Show confirmation and restart app
//       _showRestartDialog();
//     } catch (e) {
//       setState(() {
//         _restoreStatus = 'Restore failed: $e';
//       });
//       // Reopen database if restore failed
//       await DatabaseHelper.instance.database;
//     } finally {
//       setState(() => _isRestoring = false);
//     }
//   }
//
//   void _showRestartDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Text('Restore Complete'),
//         content: Text('The app needs to restart to apply the restored data'),
//         actions: [
//           TextButton(
//             child: Text('RESTART NOW'),
//             onPressed: () {
//               // This is a simplified restart - in production use a proper restart package
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 '/splash',
//                     (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }