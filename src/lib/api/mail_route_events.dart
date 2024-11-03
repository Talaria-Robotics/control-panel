import 'package:control_panel/api/navigator_models.dart';

interface class MailRouteEvent {
  late int orderNumber;
}

class ArrivedAtStopEvent extends MailRouteEvent {
  late MailRouteRoom room;
  late MailBin bin;
}

class InTransitEvent extends MailRouteEvent {
  late MailRouteRoom room;
}

class ReturnToMailroomEvent extends MailRouteEvent {}
