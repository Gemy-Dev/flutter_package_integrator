class FilePatch {
  final String filePath;
  final String pattern;
  final String? checkIsFound;
  final Action action;
  final String replacement;

  FilePatch( {this.checkIsFound, required this.action,
    required this.filePath,
    required this.pattern,
    required this.replacement,
  });
}

enum Action { replace, append, prepend }
