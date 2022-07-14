import 'server/http_handler.dart';
import 'server/http_server.dart';

void main(List<String> args) {
  final httpServer = MyHttpServer(port: 4444);

  // ADD Home Path
  httpServer.addPath("/home",
      MyHttpHandler(type: ResponseType.FILE, content: "../www/home.html"));

  // ADD Root Path
  httpServer.addPath(
      "/",
      MyHttpHandler(
          type: ResponseType.TEXT, content: "Hey this is text file."));

  // ADD login Path
  httpServer.addPath("/login",
      MyHttpHandler(type: ResponseType.JSON, content: '{"message":"hello"}'));

  httpServer.run();
}
