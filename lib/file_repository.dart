import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

class FileRepository {
  late Logger logger;
  String androidManifestPath =
      '.\\android\\app\\src\\main\\AndroidManifest.xml';
  String iosInfoPlistPath = '.\\ios\\Runner\\Info.plist';
  String androidAppBuildGradlePath = '.\\android\\app\\build.gradle';
  String iosProjectPbxprojPath = '.\\ios\\Runner.xcodeproj\\project.pbxproj';

  FileRepository() {
    logger = Logger(filter: ProductionFilter());
    if (Platform.isMacOS || Platform.isLinux) {
      androidManifestPath = 'android/app/src/main/AndroidManifest.xml';
      iosInfoPlistPath = 'ios/Runner/Info.plist';
      androidAppBuildGradlePath = 'android/app/build.gradle';
      iosProjectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';
    }
  }

  Future<List<String?>?> readFileAsLineByline(
      {required String filePath}) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      return fileAsString.split('\n');
    } catch (e) {
      return null;
    }
  }

  Future<File> writeFile({required String filePath, required String content}) {
    return File(filePath).writeAsString(content);
  }
}
