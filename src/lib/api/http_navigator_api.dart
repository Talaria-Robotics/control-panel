import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpNavigatorApi implements NavigatorApi {
  final String apiUrl;
  final int udpPort;
  RawDatagramSocket? _socket;

  HttpNavigatorApi({required this.apiUrl, required this.udpPort});
  
  HttpNavigatorApi.fromUrl(Uri url, int port)
    : apiUrl = url.authority,
      udpPort = port;

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
  Stream<MailRouteEvent> listenToRoute() async* {
    final socket = await _connectToTransitFeed();

    await for (var event in socket) {
      if (event != RawSocketEvent.read) {
        continue;
      }
      
      // Recieve data from UDP socket
      final datagram = socket.receive();
      if (datagram == null) {
        continue;
      }

      // Decode into mail route object
      final jsonText = utf8.decode(datagram.data);
      final jsonObj = json.decode(jsonText);
      yield MailRouteEvent.fromJson(jsonObj);
    }
  }
  
  @override
  Future<void> deliveryCompleted() async {
    final socket = await _connectToTransitFeed();
    
    // Encode delivery message to UTF-8
    const text = "acceptDelivery";
    final textData = utf8.encode(text);

    // Send to Navigator API
    final address = InternetAddress(apiUrl);
    socket.send(textData, address, udpPort);
  }

  Future<RawDatagramSocket> _connectToTransitFeed() async {
    return _socket ??= await RawDatagramSocket.bind(apiUrl, udpPort);
  }
}