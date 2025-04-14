import 'dart:convert';
import 'dart:io';

import 'package:flutter_package_integrator/models/file_patch.dart';

import '../const/utils/exceptions/proeject_exceptions.dart'
    show InvalidProjectException, PlatformPatchException;
import '../models/platform_config.dart';

class FileService {
  Future<void> updatePubspec(
    String path,
    Map<String, String> dependencies,
  ) async {
    final content = await File(path).readAsString();
    final buffer = StringBuffer();
    bool inDependencies = false;
    final contentAsLines = LineSplitter.split(content);

    for (final line in contentAsLines) {
      buffer.writeln(line);
      if (line.trim() == 'dependencies:') {
        inDependencies = true;
        // final index = contentAsLines.toList().indexOf(line.trim());
        //      for (final entry in dependencies.entries) {
        //     buffer.writeln('  ${entry.key}: ^${entry.value}');
        //   }
        // contentAsLines.toList().insert(
        //   index + 1,
        //   ,
        // );

        continue;
      }

      if (inDependencies && line.trim().isEmpty) {
        // Insert new dependencies
        for (final entry in dependencies.entries) {
          buffer.writeln('  ${entry.key}: ${entry.value}');
        }
        inDependencies = false;
      }
    }

    await File(path).writeAsString(buffer.toString());
  }

  Future<void> applyPlatformConfig({
    required String projectPath,
    required PlatformConfig platform,
    required Map<String, dynamic> variables,
  }) async {
    for (final patch in platform.patches) {
      final fullPath = '$projectPath/${patch.filePath}';

      if (!await exists(fullPath)) {
        throw FileSystemException('File not exsist', patch.filePath);
      }

      final content = await File(fullPath).readAsString();

      // check when add if it's fond return and not add
      // andy thing like permission or api key
      if (patch.checkIsFound != null) {
        if (content.contains(patch.checkIsFound!)) {
          throw PlatformPatchException('patch is found can\'t add it');
        }
      }
      // this is when you want to replace line
      if (patch.action == Action.replace) {
        final replaced = content.replaceAll(
          patch.pattern,
          _interpolate(patch.replacement, variables),
        );
        await File(fullPath).writeAsString(replaced);
      } else {
        // split the content into lines and loop and get index of it
        // to check the line if it equal to pattern or not
        final contentAsLines = LineSplitter.split(content);
        for (final line in contentAsLines) {
          if (line.trim() == patch.pattern) {
            final result = _addBeforOrAfter(contentAsLines, patch, line);
            await File(fullPath).writeAsString(result.join());
          }
        }
      }
    }
  }

  // this to add befor or after line not replace the line
  Iterable<String> _addBeforOrAfter(
    Iterable<String> contentAsLines,
    FilePatch patch,
    String line,
  ) {
    final index = contentAsLines.toList().indexOf(line);
    final currentIndex = patch.action == Action.append ? index + 1 : index;
    contentAsLines.toList().insert(currentIndex, patch.replacement);
    return contentAsLines;
  }

  String _interpolate(String template, Map<String, dynamic> vars) {
    return template.replaceAllMapped(RegExp(r'\$\{([^}]+)\}'), (match) {
      return vars[match[1]]?.toString() ?? '';
    });
  }

  Future<void> injectCode(String path, String? exampleCode) async {
    if (exampleCode == null) return;
    final file = await File(path).create();
    await file.writeAsString(exampleCode);
  }

  Future<void> isValidateFlutterProject(String path) async {
    if (!await exists('$path/pubspec.yaml')) {
      throw InvalidProjectException('Not a Flutter project');
    }
    if (!await isFound('flutter:', '$path/pubspec.yaml')) {
      throw InvalidProjectException('Not a Flutter project');
    }
  }

  Future<bool> isFound(String pattern, String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return content.contains(pattern);
  }

  Future<bool> exists(String path) async {
    final file = File(path);
    return file.exists();
  }
}
