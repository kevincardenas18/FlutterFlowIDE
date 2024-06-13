// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:convert' show utf8;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:download/download.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> downloadFile(String? url) async {
  // Add your function code here!
  if (url == null) {
    return [
      {'error': 'URL is null'}
    ];
  }

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final fileName = url.split('/').last;
    List<int> bytes = response.bodyBytes;

    Directory? appDir;

    if (kIsWeb) {
      // Para la web, usamos la función de descarga directa
      Stream<int> stream = Stream.fromIterable(bytes);
      await download(stream, fileName);
      return [
        {'fileName': fileName},
        {'filePath': fileName}
      ];
    } else if (Platform.isAndroid) {
      appDir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getDownloadsDirectory();
    }

    String pathName = appDir?.path ?? "";
    String destinationPath = await getDestinationPathName(fileName, pathName,
        isBackwardSlash: Platform.isWindows);

    final file = File(destinationPath);
    await file.writeAsBytes(bytes);

    return [
      {'fileName': fileName},
      {'filePath': destinationPath}
    ];
  } else {
    return [
      {'error': 'Failed to download file: $url'}
    ];
  }
}

Future<String> getDestinationPathName(String fileName, String pathName,
    {bool isBackwardSlash = true}) async {
  String destinationPath =
      pathName + "${isBackwardSlash ? "\\" : "/"}${fileName}";
  int i = 1;
  bool _isFileExists = await File(destinationPath).exists();
  while (_isFileExists) {
    _isFileExists =
        await File(pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}")
            .exists();
    if (_isFileExists == false) {
      destinationPath =
          pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}";
      break;
    }
    i++;
  }
  return destinationPath;
}
