import 'package:control_panel/api/navigator_models.dart';

abstract interface class NavigatorApi {
  Future<PossibleMailRouteInfo> getPossibleRouteInfo();

  Future<void> setRoute()
}