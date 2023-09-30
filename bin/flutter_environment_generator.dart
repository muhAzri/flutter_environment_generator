// cli.dart
import 'package:args/args.dart';
import 'package:flutter_environment_generator/flutter_environment_generator.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addCommand('start');

  final argResults = parser.parse(arguments);

  if (argResults.command == 'start') {
    final generator = FlutterEnvironmentGenerator();
    await generator.createDartDefineJson();
  } else {
    print('Usage: FlutterEnvironmentGenerator <command>');
    print('Available commands:');
    print('  start  Generate Dart environment JSON files');
  }
}
