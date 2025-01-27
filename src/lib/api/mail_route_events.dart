import 'package:control_panel/api/navigator_models.dart';

interface class MailRouteEvent {
  late int orderNumber;

  MailRouteEvent();

  factory MailRouteEvent.fromJson(Map<String, dynamic> json) {
    final type = json[r"$type"] as String;

    MailRouteEvent event = switch (type) {
      "ArrivedAtStop" => ArrivedAtStopEvent.fromJson(json),

      "InTransit" => InTransitEvent()
        ..room = MailRouteRoom.fromJson(json["room"]),

      "ReturnHome" => ReturnHomeEvent(),
      
      _ => MailRouteEvent()
    };

    event.orderNumber = json["orderNumber"] as int;
    return event;
  }
}

class ArrivedAtStopEvent extends MailRouteEvent {
  late MailRouteRoom room;
  late MailBin bin;

  ArrivedAtStopEvent();

  factory ArrivedAtStopEvent.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "room": Map<String, dynamic> room,
        "bin": Map<String, dynamic> bin,
      } =>
        ArrivedAtStopEvent()
          ..room = MailRouteRoom.fromJson(room)
          ..bin = MailBin.fromJson(bin),
      _ => throw const FormatException("Failed to parse stop event"),
    };
  }
}

class InTransitEvent extends MailRouteEvent {
  late MailRouteRoom room;

  InTransitEvent();

  factory InTransitEvent.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "room": Map<String, dynamic> room,
      } =>
        InTransitEvent()
          ..room = MailRouteRoom.fromJson(room),
      _ => throw const FormatException("Failed to parse in-transit event"),
    };
  }
}

class ReturnHomeEvent extends MailRouteEvent {}
