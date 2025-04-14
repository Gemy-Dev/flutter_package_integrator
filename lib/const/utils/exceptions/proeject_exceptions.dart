abstract class IntegrationException implements Exception {
  final String message;

  const IntegrationException(this.message);
  @override
  String toString() => '$runtimeType: $message';
}

class InvalidProjectException extends IntegrationException {
  const InvalidProjectException(super.message);
}

class PackageLoadException extends IntegrationException {
  const PackageLoadException(super.message);
}

class VersionConflictException extends IntegrationException {
  final String package;
  final String existingVersion;
  final String incomingVersion;

  const VersionConflictException(
    this.package,
    this.existingVersion,
    this.incomingVersion,
  ) : super(
        'Version conflict for $package ($existingVersion vs $incomingVersion)',
      );
}

class FileOperationException extends IntegrationException {
  final String filePath;
  final String operation;

  const FileOperationException(this.filePath, this.operation, super.message);
}

class PubspecException extends IntegrationException {
  PubspecException(super.message);
}

class PlatformPatchException extends IntegrationException {
  PlatformPatchException(super.message);
}

class PlatformException extends IntegrationException {
  final List<PlatformPatchException> exceptions;
  PlatformException(super.message,this.exceptions);
}

class CliExecutionException extends IntegrationException {
  const CliExecutionException(super.message);
}
