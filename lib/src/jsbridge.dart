class JSBridge {
  String method;
  dynamic data;
  Function? callback;

  JSBridge({
    required this.method,
    this.data,
    this.callback,
  });

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'data': data,
      'callback': callback,
    };
  }

  factory JSBridge.fromMap(Map<String, dynamic> map) {
    return JSBridge(
      method: map['method'],
      data: map['data'],
      callback: map['callback'],
    );
  }
  @override
  String toString() {
    return 'JSBridge: ${toJson()}';
  }
}
