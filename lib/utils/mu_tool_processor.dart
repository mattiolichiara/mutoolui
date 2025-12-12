import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<String> getExecutablePath() async {
  const String assetPath = 'assets/bin/mutool.exe';
  const String executableFileName = 'mutool.exe';

  final Directory tempDir = await getApplicationSupportDirectory();
  final String destinationPath = '${tempDir.path}\\$executableFileName';
  final File destinationFile = File(destinationPath);

  if (!await destinationFile.exists()) {
    try {
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await destinationFile.writeAsBytes(bytes, flush: true);
      debugPrint('Executable copied in: $destinationPath');
    } catch (e) {
      debugPrint('Error while copying from the executable: $e');
      rethrow;
    }
  }

  return destinationPath;
}

Future<ProcessResult> runExternalApp(List<String> arguments) async {
  String executablePath = await getExecutablePath();

  try {
    ProcessResult result = await Process.run(
      executablePath,
      arguments,
      runInShell: true,
    );

    debugPrint('Output: ${result.stdout}');
    debugPrint('Error: ${result.stderr}');

    return result;

  } catch (e) {
    debugPrint('Error within starting the process: $e');
    throw ProcessException(executablePath, arguments, "Error: $e", -1);
  }
}

