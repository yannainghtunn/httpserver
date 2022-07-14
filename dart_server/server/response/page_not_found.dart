class PageNotFoundResponse {
  String toResponse() {
    return """
HTTP/1.1 404 Not Found
Content-Type: text/html; charset=UTF-8

<html>
  <h1>Page Not Found</h1>
</html>
""";
  }
}
