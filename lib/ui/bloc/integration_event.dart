import 'package:flutter_package_integrator/handlers/package_handler.dart';

class IntegrationEvent {}

class SelectProject extends IntegrationEvent {
  final String path;

  SelectProject(this.path);
}

class SelectPackage extends IntegrationEvent {
  final List<String> packagesName;

  SelectPackage(this.packagesName);
}

class IntegratePackage extends IntegrationEvent {
  final List<PackageHandler> packages;

  IntegratePackage(this.packages);
}

class CompleateIntegration extends IntegrationEvent {}

class ResartIntegration extends IntegrationEvent {}
