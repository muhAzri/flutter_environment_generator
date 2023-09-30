library flutter_environment_generator;

import 'dart:convert';

import 'package:flutter_environment_generator/file_repository.dart';

FileRepository fileRepository = FileRepository();

class FlutterEnvironmentGenerator {
  Future<void> createDartDefineJson() async {
    // Define the JSON content for each environment
    final Map<String, dynamic> devEnvironment = {
      'apiBaseUrl': 'https://api.dev.example.com',
      'debugMode': true,
    };

    final Map<String, dynamic> stagingEnvironment = {
      'apiBaseUrl': 'https://api.staging.example.com',
      'debugMode': true,
    };

    final Map<String, dynamic> prodEnvironment = {
      'apiBaseUrl': 'https://api.prod.example.com',
      'debugMode': false,
    };

    // Convert maps to JSON strings
    final devJson = jsonEncode(devEnvironment);
    final stagingJson = jsonEncode(stagingEnvironment);
    final prodJson = jsonEncode(prodEnvironment);

    // Write JSON content to files
    await fileRepository.writeFile(
      filePath: 'env_dev.json',
      content: devJson,
    );

    await fileRepository.writeFile(
      filePath: 'env_staging.json',
      content: stagingJson,
    );

    await fileRepository.writeFile(
      filePath: 'env_prod.json',
      content: prodJson,
    );
  }
}
