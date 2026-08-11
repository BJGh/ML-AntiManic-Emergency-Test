import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('{"mcp_server": "Anti-Manic Emergency Test Tool Active"}');
  await for (HttpRequest req in server) {
    final body = await utf8.decoder.bind(req).join();
    final data = jsonDecode(body.isEmpty ? '{}' : body);
    bool isCrisis = (data['calc'] != "4" || data['unit'] != "kg");
    req.response..headers.contentType = ContentType.json
      ..write(jsonEncode({'status': isCrisis ? 'CRITICAL_MANIC_ALERT' : 'STABLE', 'dispatch_brigade': isCrisis}))
      ..close();
  }
}
