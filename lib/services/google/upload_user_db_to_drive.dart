import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/app_snackbar.dart';
import 'google_sign_in.dart';

Future<void> uploadUserDbToDrive() async {
  final account = await signInUserToDrive();
  if (account == null) {
    debugPrint("❌ User sign-in failed");
    return;
  }

  final authHeaders = await account.authHeaders;
  final client = authenticatedClient(
    http.Client(),
    AccessCredentials(
      AccessToken(
        'Bearer',
        authHeaders['Authorization']!.split(' ').last,
        DateTime.now().add(Duration(hours: 1)),
      ),
      null,
      ['https://www.googleapis.com/auth/drive.file'],
    ),
  );

  final driveApi = drive.DriveApi(client);
  final dbPath = await getDatabasesPath();
  final dbFile = File(join(dbPath, 'bill_mate.db'));

  final media = drive.Media(dbFile.openRead(), await dbFile.length());

  final previous = await driveApi.files.list(
    spaces: 'appDataFolder',
    q: "name='bill_mate.db'",
  );
  if (previous.files?.isNotEmpty ?? false) {
    await driveApi.files.delete(previous.files!.first.id!);
  }

  final fileMetadata = drive.File()
    ..name = 'bill_mate.db'
    ..parents = ['appDataFolder'];

  await driveApi.files.create(fileMetadata, uploadMedia: media);
  appSnackbar(message: 'Backup uploaded to your Google Drive');
}
