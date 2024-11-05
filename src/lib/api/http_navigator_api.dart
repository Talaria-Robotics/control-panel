import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    throw UnimplementedError();
  }

  @override
  Stream<MailRouteEvent> listenToRoute() async* {
    throw UnimplementedError();
  }
  
  @override
  Future<void> deliveryCompleted() async {
    throw UnimplementedError();
  }
}