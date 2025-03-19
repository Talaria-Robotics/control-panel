import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpNavigatorApi implements NavigatorApi {
  final String apiAuthority;
  final int httpPort;
  final int udpPort;
  final String apiUrl;
  RawDatagramSocket? _socket;

  HttpNavigatorApi({
    required this.apiAuthority,
    required this.httpPort,
    required this.udpPort,
  })
  : apiUrl = "$apiAuthority:$httpPort";

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
    bool madeReady = false;

    await for (var event in socket) {
      switch (event) {
        case RawSocketEvent.read:
          // Recieve data from UDP socket
          final datagram = socket.receive();
          if (datagram == null) {
            continue;
          }

          // Decode into mail route object
          final jsonText = utf8.decode(datagram.data);
          print("Received $jsonText");
          final jsonObj = json.decode(jsonText);
          yield MailRouteEvent.fromJson(jsonObj);
          break;

        case RawSocketEvent.write:
          if (!madeReady) {
            madeReady = true;
            _sendToTransitFeed("ready", socket);
          }
          break;
      }
    }
  }
  
  @override
  Future<void> deliveryCompleted() async {
    final socket = await _connectToTransitFeed();
    _sendToTransitFeed("acceptDelivery", socket);
  }

  Future<RawDatagramSocket> _connectToTransitFeed() async {
    return _socket ??= await RawDatagramSocket.bind(apiAuthority, udpPort);
  }

  void _sendToTransitFeed(String text, RawDatagramSocket socket) {
    // Encode message in UTF-8  
    final textData = utf8.encode("%$text");

    // Send to Navigator API
    final address = InternetAddress(apiAuthority);
    socket.send(textData, address, udpPort);
  }
}