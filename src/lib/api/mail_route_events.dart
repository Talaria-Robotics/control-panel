import 'package:control_panel/api/navigator_models.dart';

interface class MailRouteEvent {
  int orderNumber = 0;

  MailRouteEvent();

  factory MailRouteEvent.fromJson(Map<String, dynamic> json) {
    final type = json[r"$type"] as String;

    MailRouteEvent event = switch (type) {
      "ArrivedAtStop" => ArrivedAtStopEvent.fromJson(json),
      "InTransit" => InTransitEvent.fromJson(json),
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
  
  Map<String, dynamic> toJson() {
    return {
      r"$type": "ArrivedAtStop",
      "orderNumber": orderNumber,
      "room": room,
      "bin": bin
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
  
  Map<String, dynamic> toJson() {
    return {
      r"$type": "InTransit",
      "orderNumber": orderNumber,
      "room": room
    };
  }
}

class ReturnHomeEvent extends MailRouteEvent {
  ReturnHomeEvent();

  factory ReturnHomeEvent.fromJson(Map<String, dynamic> json) {
    return ReturnHomeEvent();
  }
  
  Map<String, dynamic> toJson() {
    return {
      r"$type": "ReturnHome",
      "orderNumber": orderNumber
    };
  }
}
