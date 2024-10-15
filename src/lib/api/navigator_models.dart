class PossibleMailRouteInfo extends Identified {
  late Iterable<MailRouteRoom> rooms;
  late Iterable<MailBin> bins;
}

class MailRouteRoom extends Identified { }

class MailBin {
  late int number;
  late String name;
}

class MailRouteStop {
  late String roomId;
  late int binNumber;
}

class RequestedMailRoute {
  late Iterable<MailRouteStop> stops;
}

interface class Identified {
  late String id;
  late String name;
}