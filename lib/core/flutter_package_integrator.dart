

import 'package:flutter_package_integrator/const/project_path.dart';
import 'package:flutter_package_integrator/const/utils/handles/either.dart';
import 'package:flutter_package_integrator/handlers/package_handler.dart';
import 'package:flutter_package_integrator/service/cli_service.dart';
import 'package:flutter_package_integrator/service/file_service.dart';

import '../const/utils/exceptions/proeject_exceptions.dart';
  
import '../models/flutter_package.dart' show FlutterPackage;
import '../models/platform_config.dart' show PlatformConfig;

typedef VoidOrException = Future<Either<IntegrationException, void>>;
typedef FlutterPackageOrException =
    Future<Either<IntegrationException, FlutterPackage>>;

class FlutterPackageIntegrator {
  // final PackageHandler _loader;
  final FileService _fileService;
  final CliService _cliService;

  FlutterPackageIntegrator({
    required PackageHandler loader,
    required FileService fileService,
    required CliService cliService,
  }) : 
       _fileService = fileService,
       _cliService = cliService;

  VoidOrException addPackageToPubspec({
    required String packageName,
    required String projectPath,
    Map<String, String> dependencies = const {},
  }) async {
    try {
      await _fileService.updatePubspec(
        '$projectPath/${Paths.pubspec}',
        dependencies,
      );
      return Either.success(null);
    } catch (e) {
      return Either.failure(
        PubspecException('Error when to add Package \n ${e.toString()}'),
      );
    }
  }
/// load package  class like google maps 
  FlutterPackageOrException loadPackage(PackageHandler package) async {
    try {
      final result = await package.load();
      return Either.success(result);
    } catch (e) {
      return Either.failure(
        PackageLoadException('Error to Load Package ${e.toString()}'),
      );
    }
  }
/// run command flutter pub get to install package
  VoidOrException runPubGet() async {
    try {
      final result = await _cliService.run('flutter pub get');
      if (result.exitCode == 0) {
        return Either.success(null);
      }
      throw Exception();
    } catch (e) {
      return Either.failure(
        CliExecutionException(
          'Error to run command [flutter pub get] ${e.toString()}',
        ),
      );
    }
  }
/// platform configration Android and ios
  VoidOrException platformConfigration({
    required List<PlatformConfig> platforms,
    required String projectPath,
    Map<String, dynamic>? configurations,
  }) async {
    List<PlatformPatchException> errors = [];
    for (final platform in platforms) {
      try {
        await _fileService.applyPlatformConfig(
          projectPath: projectPath,
          platform: platform,
          variables: configurations ?? {},
        );
      } on PlatformPatchException catch (e) {
        errors.add(e);
      } catch (e) {
        errors.add(PlatformPatchException(e.toString()));
      }
    }
    if (errors.isEmpty) {
      return Either.success(null);
    }
    return Either.failure(PlatformException('', errors));
  }


/// Add example to file not main file
  VoidOrException addExample({
    required FlutterPackage package,
    required String projectPath,
  }) async {
    try {
      await _fileService.injectCode(
        '$projectPath/${package.name}_example.dart}',
        package.exampleCode,
      );
      return Either.success(null);
    } catch (e) {
      return Either.failure(
        FileOperationException(
          projectPath,
          'create main file',
          'error to create file for example',
        ),
      );
    }
  }
  // Future<void> integrate({
  //   required String packageName,
  //   required String projectPath,
  //   Map<String, dynamic>? configurations,
  // }) async {
  //   final package = await _loader.load(packageName);

  //   await _validateProject(projectPath);

  //   await _fileService.updatePubspec(
  //     '$projectPath/${Paths.pubspec}',
  //     package.dependencies,
  //   );
  //   await _cliService.run('flutter pub get');

  //   for (final platform in package.platforms) {
  //     await _fileService.applyPlatformConfig(
  //       projectPath: projectPath,
  //       platform: platform,
  //       variables: configurations ?? {},
  //     );
  //   }
  //   if (package.exampleCode != null) {
  //     await _fileService.injectCode(
  //       '$projectPath/${Pahts.main}',
  //       package.exampleCode,
  //     );
  //   }
  // }
  Future<void> _validateProject(String path) async {
    if (!await _fileService.exists('$path/pubspec.yaml')) {
      throw InvalidProjectException('Not a Flutter project');
    }
    if (!await _fileService.isFound('flutter:', '$path/pubspec.yaml')) {
      throw InvalidProjectException('Not a Flutter project');
    }
  }
}
