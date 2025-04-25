import 'dart:async';

import 'package:control_panel/api/mail_route_events.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/routes/first_route.dart';
import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class InTransitPage extends StatefulWidget {
  const InTransitPage({super.key});

  @override
  State<StatefulWidget> createState() => _InTransitPageState();
}

class _InTransitPageState extends State<InTransitPage> {
  late final Stream<MailRouteEvent?> _stream;
  late final StreamSubscription<MailRouteEvent?> _streamListener;
  MailRouteEvent? _recentEvent;

  @override
  void initState() {
    super.initState();
    _stream = NavigatorApi.instance.listenToRoute();
    _streamListener = _stream.listen((event) {
      setState(() {
        print(event);
        _recentEvent = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    final MailRouteEvent? event = _recentEvent;

    const Widget progressBar = SizedBox(
      width: 200,
      child: LinearProgressIndicator()
    );
    
    if (event is ArrivedAtStopEvent) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Howdy"),
          Text(
            "${event.room.name}!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
          ),
          const SizedBox(height: 20),
          const Text("Your mail is in"),
          Text(
            event.bin.name,
            style: Theme.of(context).textTheme.titleLarge
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              await NavigatorApi.instance.deliveryCompleted();
            },
            child: const Text("I have received my mail")  
          )
        ],
      );
    }
    else if (event is InTransitEvent) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("In transit to"),
          Text(
            event.room.name,
            style: Theme.of(context).textTheme.displayMedium
          ),
          const SizedBox(height: 20),
          progressBar
        ],
      );
    }
    else if (event is ReturnHomeEvent) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Returning"),
          Text(
            "Home",
            style: Theme.of(context).textTheme.displayMedium
          ),
          const SizedBox(height: 20),
          progressBar
        ],
      );
    }
    else if (event is DoneEvent) {
      _streamListener.cancel();

      // Reached end of event stream
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const FirstRoute()));
    }
    else {
      body = const Center(
        child: progressBar,
      );
    }

    if (body != null) {
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

    return const Center();
  }
}
