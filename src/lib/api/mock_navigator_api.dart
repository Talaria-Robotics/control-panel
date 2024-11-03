import 'dart:io';

import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';

class MockNavigatorApi implements NavigatorApi {
  RequestedMailRoute? _requestedRoute;

  @override
  Future<PossibleMailRouteInfo> getPossibleRouteInfo() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      _getPossibleRouteInfo,
    );
  }

  PossibleMailRouteInfo _getPossibleRouteInfo() {
    return PossibleMailRouteInfo()
      ..id = "00000000-0000-0000-0000-000000000000"
      ..name = "Test Route"
      ..bins = [
        MailBin()
          ..number = 1
          ..name = "Letter Slot 1",
        MailBin()
          ..number = 2
          ..name = "Letter Slot 2",
        MailBin()
          ..number = 3
          ..name = "Letter Slot 3",
        MailBin()
          ..number = 11
          ..name = "Package Slot 1",
      ]
      ..rooms = [
        MailRouteRoom()
          ..id = "00000000-0000-0000-0000-000000000000"
          ..name = "Mail Room",
        MailRouteRoom()
          ..id = "00000000-0000-0000-0000-000000000001"
          ..name = "Room A",
        MailRouteRoom()
          ..id = "00000000-0000-0000-0000-000000000002"
          ..name = "Room B",
      ];
  }

  @override
  Future<void> setRoute(RequestedMailRoute route) async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () { _requestedRoute = route; },
    );
  }
}