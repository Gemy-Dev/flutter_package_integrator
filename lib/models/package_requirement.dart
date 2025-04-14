class PackageRequirement {
  final String key;
  final String pormpt;
  final RegExp? validation;
  final bool isOptional;

  PackageRequirement({
    required this.key,
    required this.pormpt,
    required this.validation,
    this.isOptional=false
  });
}
