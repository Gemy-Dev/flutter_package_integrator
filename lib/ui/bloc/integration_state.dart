
sealed class IntegrationState {}

class InitialIntegration extends IntegrationState {}

class LoadingIntegration extends IntegrationState {}

class AddPackgeIntegration extends IntegrationState {}

class RunPubGetIntegration extends IntegrationState {}

class PlatformIntegration extends IntegrationState {}

// /

class FailureIntegration extends IntegrationState {
  final String message;
  final Status status;

  FailureIntegration({required this.message, required this.status});
}

enum Status {
  loadPackage,
  selectedProject,
  addPackage,
  runPubGet,
  addApiKey,
  androidIntegration,
  iosIntegration,
  addExample,
  compleat,
}

