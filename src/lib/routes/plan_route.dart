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
      final stopRows = <TableRow>[];
      for (var i = 0; i < _stops.length; i++) {
        stopRows.add(buildRow(context, i));
      }

      final stopsView = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: stopRows,
      );

      final addRowButton = OutlinedButton(
        onPressed: newRow,
        child: const Text("Add Stop")
      );

      final nextButton = [
        const SizedBox(width: 8.0),
        FilledButton(
          onPressed: () {},
          child: const Text("Next"),
        )
      ];
      
      return Scaffold(
        appBar: AppBar(
          title: const Text(TalariaStrings.teamName),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: stopsView
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            addRowButton,
            if (_stops.isNotEmpty)
              ...nextButton,
          ],
        ),
      );
    }
    
    return Material(child: content);
  }

  TableRow buildRow(BuildContext context, int index) {
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

    const cellPadding = EdgeInsets.all(8.0);
    return TableRow(
      decoration: index % 2 == 0 ? BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(4.0))
      ) : null,
      children: [
        Padding(
          padding: cellPadding,
          child: Text(
            "Stop ${index + 1}",
            style: Theme.of(context).textTheme.labelLarge,
          )
        ),
        Padding(
          padding: cellPadding,
          child: roomMenu
        ),
        Padding(
          padding: cellPadding,
          child: binMenu
        )
      ]
    );
  }
}