import 'package:flutter_package_integrator/models/package_requirement.dart';
import 'package:flutter_package_integrator/models/platform_config.dart';

class FlutterPackage {
  final String name, version;
   final Map<String, String> dependencies;

  final List<PackageRequirement> requiements;
    final List<PlatformConfig> Function(Map<String, RequirementValue> requirements) platforms;

  final String? exampleCode;

  FlutterPackage(  {required this.name, required this.version,required this.requiements,  required this.platforms, required this.dependencies, required this.exampleCode});
}
