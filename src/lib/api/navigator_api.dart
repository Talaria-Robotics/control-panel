import 'package:control_panel/api/navigator_models.dart';

abstract interface class NavigatorApi {
  static late final NavigatorApi instance;

  Future<PossibleMailRouteInfo> getPossibleRouteInfo();

  Future<void> setRoute(RequestedMailRoute route);
}