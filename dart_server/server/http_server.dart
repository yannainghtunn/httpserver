import 'dart:io';
import 'dart:typed_data';

import 'http_handler.dart';
import 'http_request.dart';
import 'response/page_not_found.dart';

class MyHttpServer {
  int port;
  MyHttpServer({this.port = 4444});
  Map<String, MyHttpHandler> routes = {};

  // Add new Path to server.
  void addPath(String path, MyHttpHandler response) {
    routes[path] = response;
  }

  // Run http server on port variable.
  Future<void> run() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print("Server Listening: http://127.0.0.1:$port/");
    server.listen((client) {
      // This method invoke on new client connection.
      handleClient(client);
    });
  }

  void handleClient(Socket client) {
    String clientText = "";
    client.listen((Uint8List data) async {
      // This method invoke on new client data receive.
      clientText += String.fromCharCodes(data);
      final result =
          clientText.indexOf("\r\n\r\n"); // End client text receiving.
      if (result > 0) {
        final request =
            MyHttpRequest.fromString(clientText); // Convert to MyHttpRequest.
        if (routes[request.path] != null) {
          client.write(
              await routes[request.path]!.getResponse()); // Generate Response
        } else {
          client.write(
              PageNotFoundResponse().toResponse()); // Page Not Found Filter
        }
        client.close(); // Close Client Connection
      }
    }, onError: (error) {
      print(error);
      client.close(); // Close Client Connection
    });
  }
}
