import 'dart:io';

import '../http_handler.dart';

class FileResponse {
  MyHttpHandler handler;
  FileResponse(this.handler);
  Future<String> toResponse() async {
    final file = File(handler.content);
    int lastDot = file.path.lastIndexOf(".");
    String fileExt = file.path.substring(lastDot + 1, file.path.length);
    String contentType = "text/plain";
    switch (fileExt) {
      case "html":
        contentType = "text/html";
        break;
      case "json":
        contentType = "application/json";
        break;
    }
    handler.headers["Content-Type"] = contentType;
    String content = await file.readAsString();
    return """
HTTP/1.1 200 OK
Content-Type: $contentType

$content
""";
  }
}
