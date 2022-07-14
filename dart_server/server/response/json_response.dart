import '../http_handler.dart';

class JsonResponse {
  MyHttpHandler handler;
  JsonResponse(this.handler);
  Future<String> toResponse() async {
    return """
HTTP/1.1 200 OK
Content-Type: application/json; charset=UTF-8

${handler.content}
""";
  }
}
