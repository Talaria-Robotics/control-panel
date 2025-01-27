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
    _stream.listen((event) {
      setState(() {
        _recentEvent = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;
    final MailRouteEvent? event = _recentEvent;

    if (event is ArrivedAtStopEvent) {
      body = Column(
        children: [
          Text(
            "Howdy\r\n${event.room.name}!",
            style: Theme.of(context).textTheme.titleMedium
          ),
          const SizedBox(height: 20),
          Text("Your mail is in\r\n${event.bin.name}"),
          const SizedBox(height: 20),
          const Text("Tap the button below when you have retrieved all your items."),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () async {
              await NavigatorApi.instance.deliveryCompleted();
            },
            child: const Text("Done")  
          )
        ],
      );
    }
    else if (event is InTransitEvent) {
      body = Column(
        children: [
          const Text("In transit to"),
          Text(
            event.room.name,
            style: Theme.of(context).textTheme.displayMedium
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator()
        ],
      );
    }
    else if (event is ReturnHomeEvent) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("I'm on my way"),
          Text(
            "Home",
            style: Theme.of(context).textTheme.displayMedium
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator())
        ],
      );
    }
    else {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: TalariaHeader()
      ),
      body: Center(
        heightFactor: 0.8,
        child: body,
      )
    );
  }
}
