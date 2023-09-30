import 'dart:async';
import 'package:test/test.dart';
import '../bin/flutter_environment_generator.dart' as cli;

void main() {
  group('CLI Tests', () {
    test('Test start command', () async {
      // Set up the test case with arguments
      final arguments = ['start'];

      // Capture the standard output to check for printed messages
      final capturedOutput = await runZoned(() async {
        // Execute the main function and capture printed messages
        cli.main(arguments);
      });

      // Add debugging output to see what was captured (for diagnostic purposes)
      print('Captured Output: $capturedOutput');

      // Add your assertions here to check the printed messages
      expect(
        capturedOutput,
        contains('Usage: flutter_environment_generator <command>'),
      );
    });

    test('Test invalid command', () async {
      // Set up the test case with invalid arguments
      final arguments = ['invalid_command'];

      // Capture the standard output to check for printed messages
      final capturedOutput = await runZoned(() async {
        // Execute the main function and capture printed messages
        cli.main(arguments);
      });

      // Add debugging output to see what was captured (for diagnostic purposes)
      print('Captured Output: $capturedOutput');

      // Add your assertions here to check the printed messages
      expect(
        capturedOutput,
        contains('Usage: flutter_environment_generator <command>'),
      );
    });
  });
}
