class MyHttpRequest {
  HttpMethod method;
  String path;
  String httpVersion;
  Map<String, dynamic> headers = {};
  String? body;
  MyHttpRequest(
      {required this.method, required this.path, required this.httpVersion});
  factory MyHttpRequest.fromString(String text) {
    List<String> lines = text.split("\n");
    List<String> firstLine = lines[0].split(" ");
    String _method = firstLine[0];
    String _path = firstLine[1];
    String _httpVersion = firstLine[2];
    Map<String, String> _headers = {};
    lines.forEach(
      (element) {
        final tmp = element.split(":"); // Split header
        if (tmp.length > 1) {
          _headers[tmp[0]] = tmp[1];
        }
      },
    );
    return MyHttpRequest(
      method: _method == "POST" ? HttpMethod.POST : HttpMethod.GET,
      path: _path,
      httpVersion: _httpVersion,
    )..headers.addAll(_headers);
  }
}

enum HttpMethod { GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS, TRACE }
