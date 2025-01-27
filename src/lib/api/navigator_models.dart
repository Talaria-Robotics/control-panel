class PossibleMailRouteInfo extends Identified {
  late Iterable<MailRouteRoom> rooms;
  late Iterable<MailBin> bins;

  PossibleMailRouteInfo();

  factory PossibleMailRouteInfo.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as String;
    final name = json["name"] as String;
    final rooms = [for (Map<String, dynamic> j in json["rooms"]) MailRouteRoom.fromJson(j)];
    final bins = [for (Map<String, dynamic> j in json["bins"]) MailBin.fromJson(j)];

    return PossibleMailRouteInfo()
      ..id = id
      ..name = name
      ..rooms = rooms
      ..bins = bins;
  }
}

class MailRouteRoom extends Identified {
  MailRouteRoom();

  factory MailRouteRoom.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": String id,
        "name": String name,
      } =>
        MailRouteRoom()
          ..id = id
          ..name = name,
      _ => throw const FormatException("Failed to read the room"),
    };
  }
  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name
    };
  }
}

class MailBin {
  late int number;
  late String name;
  
  MailBin();

  factory MailBin.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "number": int number,
        "name": String name,
      } =>
        MailBin()
          ..number = number
          ..name = name,
      _ => throw const FormatException("Failed to parse mail bin"),
    };
  }
  
  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "name": name
    };
  }
}

class MailRouteStop {
  late String roomId;
  late int binNumber;
}

class RequestedMailRoute {
  late Map<int, String> stops;

  Map<String, dynamic> toJson() {
    Map<String, String> mailRouteJson = {};
    for (final stop in stops.entries) {
      mailRouteJson[stop.key.toString()] = stop.value;
    }
    return mailRouteJson;
  }
}

interface class Identified {
  late String id;
  late String name;
}