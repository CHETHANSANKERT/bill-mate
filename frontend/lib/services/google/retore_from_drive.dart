// import 'dart:io';
// import 'package:bill_mate/utils/app_snackbar.dart';
// import 'package:googleapis_auth/auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// import 'google_sign_in.dart';
//
// Future<void> restoreUserDbFromDrive() async {
//   final account = await signInUserToDrive();
//   if (account == null) return;
//
//   final authHeaders = await account.authHeaders;
//   final client = authenticatedClient(
//     http.Client(),
//     AccessCredentials(
//       AccessToken(
//         'Bearer',
//         authHeaders['Authorization']!.split(' ').last,
//         DateTime.now().add(Duration(hours: 1)),
//       ),
//       null,
//       ['https://www.googleapis.com/auth/drive.file'],
//     ),
//   );
//
//   final driveApi = drive.DriveApi(client);
//   final files = await driveApi.files.list(
//     spaces: 'appDataFolder',
//     q: "name='bill_mate.db'",
//   );
//
//   if (files.files == null || files.files!.isEmpty) {
//     appSnackbar(message: '❌ No backup found in Drive');
//     return;
//   }
//
//   final fileId = files.files!.first.id!;
//   final media = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
//
//   final dbPath = await getDatabasesPath();
//   final file = File(join(dbPath, 'bill_mate.db'));
//
//   final sink = file.openWrite();
//   await media.stream.pipe(sink);
//   await sink.flush();
//   await sink.close();
// }
