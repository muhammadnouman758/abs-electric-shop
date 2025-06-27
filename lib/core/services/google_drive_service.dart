// core/services/google_drive_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
    scopes: [
      DriveApi.driveFileScope,
    ],
  );

  Future<bool> signIn() async {
    try {
      await _googleSignIn.signIn();
      return true;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<bool> uploadFile(String filePath, String fileName) async {
    try {
      final googleAuth = await _googleSignIn.authenticatedClient();
      if (googleAuth == null) {
        throw Exception('Not authenticated with Google');
      }

      final drive = DriveApi(googleAuth);
      final file = File();
      file.name = fileName;

      // final fileBytes = await File(filePath).readAsBytes();

      // await drive.files.create(
      //   file,
      //   uploadMedia: Media(
      //     Stream.value(fileBytes),
      //     fileBytes.length,
      //   ),
      // );

      return true;
    } catch (error) {
      print('Google Drive Upload Error: $error');
      return false;
    }
  }

  Future<List<File>> listFiles() async {
    try {
      final googleAuth = await _googleSignIn.authenticatedClient();
      if (googleAuth == null) {
        throw Exception('Not authenticated with Google');
      }

      final drive = DriveApi(googleAuth);
      final response = await drive.files.list(
        q: "mimeType != 'application/vnd.google-apps.folder'",
        $fields: 'files(id, name, modifiedTime, size)',
      );

      return response.files ?? [];
    } catch (error) {
      print('Google Drive List Error: $error');
      return [];
    }
  }
}