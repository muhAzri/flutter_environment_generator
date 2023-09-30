// ignore_for_file: avoid_print

import 'package:args/args.dart';
import 'package:flutter_environment_generator/flutter_environment_generator.dart';

final generator = FlutterEnvironmentGenerator();

/// Entry point for the Flutter Environment Generator CLI.
void main(List<String> arguments) async {
  final parser = ArgParser()..addCommand('start');

  final argResults = parser.parse(arguments);
  final command = argResults.command;

  if (command?.name == 'start') {
    final generator = FlutterEnvironmentGenerator();
    await generator.start();
  } else {
    print('Usage: flutter_environment_generator <command>');
    print('Available commands:');
    print('  start  Generate Dart environment JSON files');
  }
}
