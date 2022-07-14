import '../http_handler.dart';

class TextResponse {
  MyHttpHandler handler;
  TextResponse(this.handler);
  Future<String> toResponse() async {
    return """
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8

${handler.content}
""";
  }
}
