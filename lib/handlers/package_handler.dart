import '../models/flutter_package.dart' show FlutterPackage;

abstract class PackageHandler {
  String get packageName;
  String get displayName;

  bool canHandle(String packageId)=>packageId==packageName;
  Future<FlutterPackage> load();
  // Future<void> preIntegration({
  //   required String projectPath,
  //   required Map<String, dynamic> configs,
  // });
  // Future<void> posIntegrate({
  //   required String projectPath,
  //   required Map<String, dynamic> configs,
  // });
  // Future<void> validate({
  //   required String projectPath,
  //   required Map<String, dynamic> configs,
  // });
  // Future<List<String>> getAffectedFiles(String projectPath);
}
