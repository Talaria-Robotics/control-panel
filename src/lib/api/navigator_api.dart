import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_models.dart';

abstract interface class NavigatorApi {
  static late final NavigatorApi instance;

  Future<PossibleMailRouteInfo> getPossibleRouteInfo();

  Future<void> setRoute(RequestedMailRoute route);

  Stream<MailRouteEvent> listenToRoute();

  Future<void> deliveryCompleted();
}