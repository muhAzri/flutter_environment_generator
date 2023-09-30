import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:yaml/yaml.dart';

/// A repository for file-related operations.
class FileRepository {
  late Logger logger;
  String androidManifestPath =
      '.\\android\\app\\src\\main\\AndroidManifest.xml';
  String iosInfoPlistPath = '.\\ios\\Runner\\Info.plist';
  String androidAppBuildGradlePath = '.\\android\\app\\build.gradle';
  String iosProjectPbxprojPath = '.\\ios\\Runner.xcodeproj\\project.pbxproj';

  /// Constructs a [FileRepository] instance.
  FileRepository()
      : androidManifestPath = Platform.isWindows
            ? '.\\android\\app\\src\\main\\AndroidManifest.xml'
            : 'android/app/src/main/AndroidManifest.xml',
        iosInfoPlistPath = Platform.isWindows
            ? '.\\ios\\Runner\\Info.plist'
            : 'ios/Runner/Info.plist',
        androidAppBuildGradlePath = Platform.isWindows
            ? '.\\android\\app\\build.gradle'
            : 'android/app/build.gradle',
        iosProjectPbxprojPath = Platform.isWindows
            ? '.\\ios\\Runner.xcodeproj/project.pbxproj'
            : 'ios/Runner.xcodeproj/project.pbxproj' {
    logger = Logger(filter: ProductionFilter());
  }

  /// Reads a file and returns its content as a list of lines.
  Future<List<String?>?> readFileAsLineByline(
      {required String filePath}) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      return fileAsString.split('\n');
    } catch (e) {
      return null;
    }
  }

  /// Writes content to a file.
  Future<File> writeFile({required String filePath, required String content}) {
    return File(filePath).writeAsString(content);
  }

  /// Generates a JSON ENV File For Dart Define
  Future<void> generateEnvFile() async {
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

    // Convert maps to JSON strings with prettified formatting
    final devJson = const JsonEncoder.withIndent('  ').convert(devEnvironment);
    final stagingJson =
        const JsonEncoder.withIndent('  ').convert(stagingEnvironment);
    final prodJson =
        const JsonEncoder.withIndent('  ').convert(prodEnvironment);

    // Write JSON content to files
    await writeFile(
      filePath: 'env_dev.json',
      content: devJson,
    );

    await writeFile(
      filePath: 'env_staging.json',
      content: stagingJson,
    );

    await writeFile(
      filePath: 'env_prod.json',
      content: prodJson,
    );
  }

  /// Generates VS Code launch configurations based on environment settings.
  Future<void> createLaunchJson() async {
    // Load the pubspec.yaml file from the Flutter project
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      logger.e('pubspec.yaml not found in the current directory.');
      return;
    }

    final pubspecContent = pubspecFile.readAsStringSync();
    final pubspecYaml = loadYaml(pubspecContent);

    final appName = pubspecYaml['name'];

    if (appName == null) {
      logger.e('Error: Unable to find the app name in pubspec.yaml.');
      return;
    }

    final vscodeDir = Directory('.vscode');
    if (!vscodeDir.existsSync()) {
      vscodeDir.createSync();
    }

    // Define the launch configurations
    final launchConfigurations = [
      {
        "name": "$appName dev",
        "request": "launch",
        "type": "dart",
        "args": ["--flavor", "dev", "--dart-define-from-file", "env_dev.json"]
      },
      {
        "name": "$appName (profile mode) dev",
        "request": "launch",
        "type": "dart",
        "flutterMode": "profile",
        "args": ["--flavor", "dev", "--dart-define-from-file", "env_dev.json"]
      },
      {
        "name": "$appName (release mode) dev",
        "request": "launch",
        "type": "dart",
        "flutterMode": "release",
        "args": ["--flavor", "dev", "--dart-define-from-file", "env_dev.json"]
      },
      {
        "name": "$appName staging",
        "request": "launch",
        "type": "dart",
        "args": [
          "--flavor",
          "staging",
          "--dart-define-from-file",
          "env_staging.json"
        ]
      },
      {
        "name": "$appName (profile mode) staging",
        "request": "launch",
        "type": "dart",
        "flutterMode": "profile",
        "args": [
          "--flavor",
          "staging",
          "--dart-define-from-file",
          "env_staging.json"
        ]
      },
      {
        "name": "$appName (release mode) staging",
        "request": "launch",
        "type": "dart",
        "flutterMode": "release",
        "args": [
          "--flavor",
          "staging",
          "--dart-define-from-file",
          "env_staging.json"
        ]
      },
      {
        "name": "$appName prod",
        "request": "launch",
        "type": "dart",
        "args": ["--flavor", "prod", "--dart-define-from-file", "env_prod.json"]
      },
      {
        "name": "$appName (profile mode) prod",
        "request": "launch",
        "type": "dart",
        "flutterMode": "profile",
        "args": ["--flavor", "prod", "--dart-define-from-file", "env_prod.json"]
      },
      {
        "name": "$appName (release mode) prod",
        "request": "launch",
        "type": "dart",
        "flutterMode": "release",
        "args": ["--flavor", "prod", "--dart-define-from-file", "env_prod.json"]
      }
    ];

    // Write the launch configuration JSON to a file
    final launchConfigFile = File('.vscode/launch.json');
    final launchConfigJson = {
      "version": "0.2.0",
      "configurations": launchConfigurations
    };
    await launchConfigFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(launchConfigJson),
      flush: true,
    );
  }

  /// Updates the build.gradle file with flavor configurations.
  Future<void> updateBuildGradle() async {
    final buildGradleFile = File(androidAppBuildGradlePath);
    final pubspecFile = File('pubspec.yaml');

    if (!await buildGradleFile.exists()) {
      logger.e('build.gradle file not found.');
      return;
    }

    final buildGradleLines = await buildGradleFile.readAsLines();

    // Check if the flavor configuration section already exists.
    bool flavorConfigExists = false;
    for (var i = 0; i < buildGradleLines.length; i++) {
      if (buildGradleLines[i].contains('flavorDimensions') &&
          buildGradleLines[i + 2].contains('productFlavors {')) {
        flavorConfigExists = true;
        break;
      }
    }

    if (!flavorConfigExists) {
      // Find the application ID in build.gradle.
      String? applicationId;

      for (var line in buildGradleLines) {
        if (line.contains('namespace')) {
          final parts = line.split('"');
          if (parts.length >= 2) {
            applicationId = parts[1];
            break;
          }
        }
      }

      final pubspecContent = await pubspecFile.readAsString();
      final pubspecYaml = loadYaml(pubspecContent);

      final resValueString = pubspecYaml['name'] as String?;

      // Add the new flavor configuration section.
      final flavorConfigurations = '''
      flavorDimensions  'app'

      productFlavors {
          dev {
              dimension "app"
              resValue "string", "app_name", "$resValueString Dev"
              versionNameSuffix "-dev"
              applicationId "$applicationId.dev"
          }
          staging {
              dimension "app"
              resValue "string", "app_name", "$resValueString Staging "
              versionNameSuffix "-stg"
              applicationId "$applicationId.staging"
          }
          prod {
              dimension "app"
              resValue "string", "app_name", "$resValueString"
              applicationId "$applicationId"
          }
      }
      ''';

      // Find the location to insert flavor configurations.
      int insertIndex = -1;
      for (var i = 0; i < buildGradleLines.length; i++) {
        if (buildGradleLines[i].contains('defaultConfig {')) {
          insertIndex = i;
          break;
        }
      }

      if (insertIndex == -1) {
        logger.e('Could not find defaultConfig section in build.gradle.');
        return;
      }

      // Insert the new flavor configurations.
      buildGradleLines.insertAll(insertIndex, flavorConfigurations.split('\n'));

      await buildGradleFile.writeAsString(buildGradleLines.join('\n'));
    } else {
      logger.i('Flavor configuration already exists in build.gradle.');
    }
  }

  /// Changes the label attribute in AndroidManifest.xml to use a resource.
  Future<void> changeManifestLabelToResource() async {
    final manifestFile = File(androidManifestPath);

    if (!await manifestFile.exists()) {
      logger.e('AndroidManifest.xml file not found.');
      return;
    }

    final manifestLines = await manifestFile.readAsLines();

    for (int i = 0; i < manifestLines.length; i++) {
      final line = manifestLines[i];
      if (line.contains('android:label=')) {
        // Check if the android:label attribute contains a string value.
        final labelIndex = line.indexOf('android:label=');
        final quoteStartIndex = line.indexOf('"', labelIndex);
        final quoteEndIndex = line.indexOf('"', quoteStartIndex + 1);

        if (quoteStartIndex != -1 && quoteEndIndex != -1) {
          final currentValue =
              line.substring(quoteStartIndex + 1, quoteEndIndex);
          const newValue = '@string/app_name';

          if (currentValue != newValue) {
            // Replace the android:label value with @string/name.
            manifestLines[i] = line.replaceFirst(currentValue, newValue);
            await manifestFile.writeAsString(manifestLines.join('\n'));
            logger.i('AndroidManifest.xml label updated to use @string/name');
            return;
          }
        }
      }
    }
  }
}
