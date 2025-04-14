import 'package:flutter_package_integrator/models/file_patch.dart';

class PlatformConfig {
  final PlatFormType platform;
  final List<FilePatch>  patches;

  PlatformConfig({required this.platform, required this.patches});


 
}
class RequirementValue {
  final String value;
  final bool isValid;

  RequirementValue({required this.value, required this.isValid});
}
enum PlatFormType { android, ios }
