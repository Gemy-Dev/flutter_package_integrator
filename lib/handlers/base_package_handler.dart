import 'package:flutter_package_integrator/handlers/package_handler.dart';

abstract class BasePackageHandler implements PackageHandler {
  @override
  final String packageName;

  const BasePackageHandler(this.packageName);
  @override
  bool canHandle(String packageId) => packageId == packageName;
}
