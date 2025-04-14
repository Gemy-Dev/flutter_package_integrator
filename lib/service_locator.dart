import 'package:flutter_package_integrator/core/package_loader.dart';
import 'package:flutter_package_integrator/handlers/google_map_handler.dart';
import 'package:flutter_package_integrator/handlers/package_handler.dart';
import 'package:flutter_package_integrator/service/cli_service.dart';
import 'package:flutter_package_integrator/service/file_service.dart';
import 'package:flutter_package_integrator/ui/bloc/integration_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shell/shell.dart';

final sl = GetIt.instance;

Future<void> serviceLocatorInit() async {

  sl.registerFactory(IntegrationBloc(flutterPackageIntegrator: sl(),fileService: sl()) as FactoryFunc<Object>);

  sl.registerLazySingleton<PackageHandler>(GoogleMapHandler() as FactoryFunc<PackageHandler>);

  sl.registerLazySingleton(CliService(shell: sl()) as FactoryFunc<Object>);
  sl.registerLazySingleton(FileService() as FactoryFunc<PackageHandler>);
  
  
  
  sl.registerLazySingleton(Shell() as FactoryFunc<PackageHandler>);

 
}
