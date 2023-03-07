class PathParts {
  final String root;
  final List<String> parts;
  final String separator;

  const PathParts(this.root, this.parts, this.separator);

  factory PathParts.parse(String path) {
    late final String root;
    late final String separator;

    if (path.startsWith("/")) {
      root = "/";
      separator = "/";
    } else if (path.startsWith(RegExp(r"[A-Z]:\\", caseSensitive: false))) {
      root = RegExp(r"^[A-Z]:\\", caseSensitive: false)
          .firstMatch(path)!
          .group(0)!;
      separator = "\\";
    }
    final String cleanPath = path.replaceFirst(root, "");

    late final List<String> parts;
    if (cleanPath.isNotEmpty) {
      parts = path.replaceFirst(root, "").split(separator);
    } else {
      parts = [];
    }

    return PathParts(root, parts, separator);
  }

  String toPath([int? numOfParts]) {
    final int resolvedNumOfParts = numOfParts ?? parts.length;
    assert(resolvedNumOfParts >= 0 && resolvedNumOfParts <= parts.length);
    final List<String> transformedPathParts =
        parts.sublist(0, resolvedNumOfParts);
    final String path = transformedPathParts.join(separator);

    return "$root$path";
  }

  PathParts trim(int numOfParts) {
    assert(numOfParts >= 0 && numOfParts <= parts.length);
    final List<String> transformedPathParts = parts.sublist(0, numOfParts);

    return PathParts(root, transformedPathParts, separator);
  }

  List<String> get integralParts => [root, ...parts];

  @override
  String toString() {
    return {
      "root": root,
      "parts": parts,
      "separator": separator,
    }.toString();
  }
}
