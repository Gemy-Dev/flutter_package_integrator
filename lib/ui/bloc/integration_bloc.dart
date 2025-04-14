import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_package_integrator/core/flutter_package_integrator.dart';
import 'package:flutter_package_integrator/handlers/package_handler.dart';
import 'package:flutter_package_integrator/models/flutter_package.dart';
import 'package:flutter_package_integrator/models/platform_config.dart';
import 'package:flutter_package_integrator/service/file_service.dart';

import 'integration.dart';

class IntegrationBloc extends Bloc<IntegrationEvent, IntegrationState> {
  final FlutterPackageIntegrator _flutterPackageIntegrator;
  final FileService _fileService;
  final Queue _packagesOperations;

  IntegrationBloc({
    required FlutterPackageIntegrator flutterPackageIntegrator,
    required FileService fileService,
  }) : _flutterPackageIntegrator = flutterPackageIntegrator,
       _fileService = fileService,
       _packagesOperations = Queue(),
       super(InitialIntegration()) {
    on<SelectProject>(_selectPackage);
    on<IntegratePackage>(_onPackagesIntegration);
  }

  FutureOr<void> _selectPackage(
    SelectProject event,
    Emitter<IntegrationState> emit,
  ) async {
    try {
      await _fileService.isValidateFlutterProject(event.path);
    } catch (e) {
      emit(
        FailureIntegration(
          message: e.toString(),
          status: Status.selectedProject,
        ),
      );
    }
  }

  FutureOr<void> _onPackagesIntegration(
    IntegratePackage event,
    Emitter<IntegrationState> emit,
  ) {
    for (final package in event.packages) {
      _onLoadPackage((package) async {
        await _addPackageToPubspec(package);
        await _runPubGet();
        _checkRequirements();
        await _platformConfigrations(package: package, requirements: {});
      }, package);
    }
  }

  Future<void> _onLoadPackage(
    Function(FlutterPackage package) onPackageLoad,
    PackageHandler package,
  ) async {
    final result = await _flutterPackageIntegrator.loadPackage(package);
    result.match(
      onRight: (flutterPackage) {
        onPackageLoad(flutterPackage!);
      },
      onLeft: (error) {
        emit(
          FailureIntegration(message: error.message, status: Status.addPackage),
        );
      },
    );
  }

  _addPackageToPubspec(FlutterPackage package) async {
    final result = await _flutterPackageIntegrator.addPackageToPubspec(
      packageName: package.name,
      projectPath: 'event.',
    );
    result.match(
      onRight: (_) {
        emit(AddPackgeIntegration());
      },
      onLeft: (error) {
        emit(
          FailureIntegration(message: error.message, status: Status.addPackage),
        );
      },
    );
  }

  _runPubGet() async {
    final result = await _flutterPackageIntegrator.runPubGet();
    result.match(
      onRight: (_) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(RunPubGetIntegration());
      },
      onLeft: (error) {
        emit(
          FailureIntegration(message: error.message, status: Status.runPubGet),
        );
      },
    );
  }

  _platformConfigrations({
    required FlutterPackage package,
    Map<String, RequirementValue>? requirements,
  }) async {
    final result = await _flutterPackageIntegrator.platformConfigration(
      platforms: package.platforms(requirements ?? {}),
      projectPath: 'projectPath',
    );
    result.match(
      onRight: (_) {
        emit(PlatformIntegration());
      },
      onLeft: (error) {
        emit(
          FailureIntegration(
            message: error.message,
            status: Status.androidIntegration,
          ),
        );
      },
    );
  }
  
  void _checkRequirements() {
    
  }
}
