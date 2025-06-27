
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import 'google_drive_service.dart';

class SyncService {
  final DatabaseHelper _databaseHelper;
  final GoogleDriveService _googleDriveService;

  SyncService(this._databaseHelper, this._googleDriveService);

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncData() async {
    final isConnected = await checkConnectivity();
    if (!isConnected) return;

    // try
    // {
    //   // 1. Check if we have pending local changes
    //   final pendingChanges = await _databaseHelper.getPendingSyncRecords();
    //
    //   if (pendingChanges.isNotEmpty) {
    //     // 2. Upload changes to Google Drive
    //     await _googleDriveService.uploadChanges(pendingChanges);
    //
    //     // 3. Mark records as synced
    //     await _databaseHelper.markRecordsAsSynced(pendingChanges);
    //   }
    //
    //   // 4. Check for remote changes
    //   final remoteChanges = await _googleDriveService.getRemoteChanges();
    //
    //   if (remoteChanges.isNotEmpty) {
    //     // 5. Apply remote changes to local database
    //     await _databaseHelper.applyRemoteChanges(remoteChanges);
    //   }
    //
    //   // 6. Update last sync timestamp
    //   await _databaseHelper.updateLastSyncTimestamp(DateTime.now());
    // } catch (e) {
    //   print('Sync failed: $e');
    //   // Implement retry logic or error handling
    // }
  }

  Future<void> schedulePeriodicSync() async {

      await syncData();
  }
}