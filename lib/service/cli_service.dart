import 'dart:io';

import 'package:shell/shell.dart';

import '../const/utils/exceptions/proeject_exceptions.dart' show CliExecutionException;

class CliService {
  final Shell _shell;

  CliService({Shell? shell}) : _shell = shell ?? Shell();

  Future<ProcessResult> run(
    String command, {
    Iterable<String>? arguments,
  }) async {
    try {
      final result = await _shell.run(command, arguments: arguments ?? []);

      if (result.exitCode != 0) {
        throw ProcessException(
          command,
          result.exitCode as List<String>,
          result.stderr.toString(),
        );
      }

      return result;
    } on ProcessException catch (e) {
      throw CliExecutionException(
        'Command failed: $command\n'
        'Exit code: ${e.errorCode}\n'
        'Error: ${e.message}',
      );
    }
  }

  Future<bool> isFlutterAvailable() async {
    try {
      final result = await run('flutter --version');
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }
}

