import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'package:control_panel/strings.dart';
import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  const PlanRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  PossibleMailRouteInfo? _route;
  final List<MailRouteStop> _stops = [];

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    final routeInfo = await NavigatorApi.instance.getPossibleRouteInfo();
    setState(() {
      _route = routeInfo;
    });
  }

  void newRow() {
    setState(() {
      newStop();
    });
  }

  void newStop() {
    final newStop = MailRouteStop()
      ..binNumber = _route!.bins.first.number
      ..roomId = _route!.rooms.first.id;
    _stops.add(newStop);
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;

    if (_route == null) {
      content = const Center(child: CircularProgressIndicator());
    }
    else {
      final stopsView = ListView.builder(
        itemCount: _stops.length,
        itemBuilder: buildRow,
      );

      final addRowButton = FilledButton(
        onPressed: newRow,
        child: const Text("Add Stop")
      );
      
      content = Stack(
        alignment: Alignment.bottomRight,
        children: [
          stopsView,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: addRowButton
          ),
        ],
      );
    }
    
    return Material(child: content);
  }

  Widget buildRow(BuildContext context, int index) {
    final stop = _stops[index];
    
    final roomOptions = <DropdownMenuEntry<MailRouteRoom>>[];
    for (final room in _route!.rooms) {
      final dropdownOption = DropdownMenuEntry(
        value: room,
        label: room.name,
      );
      roomOptions.add(dropdownOption);
    }
    final roomMenu = DropdownMenu(
      label: const Text("Room"),
      onSelected: (value) {
        if (value != null) {
          stop.roomId = value.id;
        }
       },
      dropdownMenuEntries: roomOptions,
    );

    final binOptions = <DropdownMenuEntry<MailBin>>[];
    for (final bin in _route!.bins) {
      final dropdownOption = DropdownMenuEntry(
        value: bin,
        label: bin.name,
      );
      binOptions.add(dropdownOption);
    }
    final binMenu = DropdownMenu(
      label: const Text("Bin"),
      onSelected: (value) {
        if (value != null) {
          stop.binNumber = value.number;
        }
      },
      dropdownMenuEntries: binOptions,
    );

    return ListTile(
      leading: Text("Stop ${index + 1}"),
      title: Row(
        children: [
          roomMenu,
          binMenu
        ]
      )
    );
  }
}