extension ObjectEx on Object {
  int? toInt() => _toInt();
}

extension on Object {
  int? _toInt() {
    return int.tryParse(toString());
  }
}

T? cast<T>(x) => x is T ? x : null;
