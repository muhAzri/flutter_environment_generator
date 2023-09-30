library flutter_environment_generator;

import 'package:flutter_environment_generator/file_repository.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();
FileRepository fileRepository = FileRepository();

/// A generator for Flutter environment settings.
class FlutterEnvironmentGenerator {
  /// Starts the environment generation process.
  Future<void> start() async {
    await createDartDefineJson();
    await generateVSCodeLaunchConfig();
    await updateGradleFlavor();
    await updateAndroidManifest();
  }

  /// Generates environment JSON files with predefined settings.
  Future<void> createDartDefineJson() async {
    await fileRepository.generateEnvFile();
  }

  /// Generates VS Code launch configurations based on environment settings.
  Future<void> generateVSCodeLaunchConfig() async {
    await fileRepository.createLaunchJson();
  }

  /// Updates the Gradle build file with flavor configurations.
  Future<void> updateGradleFlavor() async {
    await fileRepository.updateBuildGradle();
  }

  /// Updates the AndroidManifest.xml to use a resource for the app label.
  Future<void> updateAndroidManifest() async {
    await fileRepository.changeManifestLabelToResource();
  }
}
