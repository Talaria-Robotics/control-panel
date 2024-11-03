import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';

class MockNavigatorApi implements NavigatorApi {
  RequestedMailRoute? _requestedRoute;
  bool _isConfirmed = false;

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

  @override
  Stream<MailRouteEvent> listenToRoute() async* {
    if (_requestedRoute == null) {
      throw StateError("No route was requested.");
    }

    final routeInfo = _getPossibleRouteInfo();
    int currentOrder = 0;

    for (final stop in _requestedRoute!.stops.entries) {
      await Future.delayed(const Duration(seconds: 1));

      final room = routeInfo.rooms.firstWhere((r) => r.id == stop.value);
      final bin = routeInfo.bins.firstWhere((b) => b.number == stop.key);

      // Begin navigating to next stop
      yield InTransitEvent()
        ..room = room
        ..orderNumber = currentOrder++;
      
      await Future.delayed(const Duration(seconds: 10));

      // Arrived at stop
      yield ArrivedAtStopEvent()
        ..room = room
        ..bin = bin
        ..orderNumber = currentOrder++;

      await Future.doWhile(() {
        return !_isConfirmed;
      });

      _isConfirmed = false;
    }

    yield ReturnToMailroomEvent()
      ..orderNumber = currentOrder;
  }
  
  @override
  Future<void> deliveryCompleted() async {
    Future.delayed(const Duration(seconds: 1));
    _isConfirmed = true;
  }
}