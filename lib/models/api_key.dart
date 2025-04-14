class ApiKey {
  final String? _androidKey;
  final String? _iosKey;

 const ApiKey({String? androidKey, String? iosKey})
    : _androidKey = androidKey,
      _iosKey = iosKey;

  bool get hasAndroidKey => _androidKey != null;
  bool get hasAIosKey => _iosKey != null;

  String? get androidKey => _androidKey;
  String? get iosKey => _iosKey;

  copyWith({String? androidKey, String? iosKey}) =>
      ApiKey(androidKey: androidKey ?? _androidKey, iosKey: iosKey ?? _iosKey);
}
