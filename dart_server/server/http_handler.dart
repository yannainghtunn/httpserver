import 'response/file_response.dart';
import 'response/json_response.dart';
import 'response/text_response.dart';

class MyHttpHandler {
  Map<String, String> headers = {};
  String content;
  ResponseType type;
  MyHttpHandler({required this.type, required this.content});

  // GET Response data.
  Future<String> getResponse() async {
    if (type == ResponseType.FILE) {
      // Read File and return String
      return await FileResponse(this).toResponse();
    } else if (type == ResponseType.JSON) {
      // Return Json Type
      return JsonResponse(this).toResponse();
    } else {
      // Return Text
      return await TextResponse(this).toResponse();
    }
  }
}

enum ResponseType { FILE, TEXT, JSON }
