import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpNavigatorApi implements NavigatorApi {
  final String apiUrl;

  HttpNavigatorApi({required this.apiUrl});
  
  HttpNavigatorApi.fromUrl(Uri url)
    : apiUrl = url.authority;

  @override
  Future<PossibleMailRouteInfo> getPossibleRouteInfo() async {
    final response = await http
      .get(Uri.http(apiUrl, "possibleRoute"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PossibleMailRouteInfo.fromJson(json);
    } else {
      throw Exception("Failed to load route info");
    }
  }

  @override
  Future<void> setRoute(RequestedMailRoute route) async {
    final routeJson = json.encode(route);
    await http.post(
      Uri.http(apiUrl, "route"),
      headers: {"Content-Type": "application/json"},
      body: routeJson);
  }

  @override
  Stream<MailRouteEvent> listenToRoute() {
    final transitFeedUri = Uri
      .http(apiUrl, "transitFeed")
      .replace(scheme: "ws");

    final _channel = WebSocketChannel.connect(transitFeedUri);
    return _channel.stream.map((jsonText) {
      final jsonObj = json.decode(jsonText);
      return MailRouteEvent.fromJson(jsonObj);
    });
  }
  
  @override
  Future<void> deliveryCompleted() async {
    throw UnimplementedError();
  }
}