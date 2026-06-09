// import 'dart:io';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// Future<void> uploadToGoogleDrive(GoogleSignInAccount account) async {
//   final dbPath = await getDatabasesPath();
//   final filePath = join(dbPath, 'bill_mate.db');
//   final authHeaders = await account.authHeaders;
//   final authenticateClient = GoogleAuthClient(authHeaders);
//
//   final driveApi = drive.DriveApi(authenticateClient);
//
//   var fileToUpload = drive.File();
//   fileToUpload.name = "backup.db";
//
//   final file = File(filePath);
//   await driveApi.files.create(
//     fileToUpload,
//     uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
//   );
// }
//
// class GoogleAuthClient extends http.BaseClient {
//   final Map<String, String> _headers;
//   final http.Client _client = http.Client();
//
//   GoogleAuthClient(this._headers);
//
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _client.send(request..headers.addAll(_headers));
//   }
//
//   @override
//   void close() {
//     _client.close();
//   }
// }
