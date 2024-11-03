import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class InTransitPage extends StatefulWidget {
  const InTransitPage({super.key});

  @override
  State<StatefulWidget> createState() => _InTransitPageState();
}

class _InTransitPageState extends State<InTransitPage> {
  late final Stream<MailRouteEvent> _stream;
  MailRouteEvent? _recentEvent;

  @override
  void initState() {
    super.initState();
    _stream = NavigatorApi.instance.listenToRoute();
    _stream.listen(onEvent);
  }

  void onEvent(MailRouteEvent event) {
    print(event.orderNumber);

    if (event is InTransitEvent) {
      print(event.room.name);
    }
    else if (event is ArrivedAtStopEvent) {
      print(event.room.name);
      print(event.bin.name);
    }

    setState(() {
      _recentEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: TalariaHeader()
      ),
      body: Text(_recentEvent?.orderNumber.toString() ?? "waiting")
    );
  }
}
