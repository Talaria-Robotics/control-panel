import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  const PlanRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  bool _loading = true;
  PossibleMailRouteInfo? _route;
  final Map<int, String> _stops = {};

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    final routeInfo = await NavigatorApi.instance.getPossibleRouteInfo();
    setState(() {
      _loading = false;
      _route = routeInfo;
    });
  }

  Future<void> next() async {
    setState(() {
      _loading = true;
    });
    
    final requestedRoute = RequestedMailRoute()
      ..stops = _stops;
    await NavigatorApi.instance.setRoute(requestedRoute);

    // TODO: Navigate to confirmation screen
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;

    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    }
    else {
      final stopRows = <TableRow>[];
      for (final bin in _route!.bins) {
        stopRows.add(buildRow(context, bin));
      }

      final stopsView = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: IntrinsicColumnWidth()},
        children: stopRows,
      );

      final nextButton = [
        const SizedBox(width: 8.0),
        FilledButton(
          onPressed: _stops.isNotEmpty ? next : null,
          child: const Text("Next"),
        )
      ];
      
      return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.maxFinite, 50),
          child: TalariaHeader()
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: stopsView
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: nextButton,
        ),
      );
    }
    
    return Material(child: content);
  }

  TableRow buildRow(BuildContext context, final MailBin bin) {
    const menuButtonInsets = EdgeInsets.symmetric(horizontal: 0);
    
    final roomOptions = <DropdownMenuEntry<MailRouteRoom?>>[
      const DropdownMenuEntry<MailRouteRoom?>(value: null, label: " ")
    ];

    for (final room in _route!.rooms) {
      final dropdownOption = DropdownMenuEntry(
        value: room,
        label: room.name,
      );
      roomOptions.add(dropdownOption);
    }
    final roomMenu = DropdownMenu(
      label: const Text("Room"),
      enableSearch: false,
      expandedInsets: menuButtonInsets,
      onSelected: (value) {
        if (value != null) {
          setState(() {
            _stops[bin.number] = value.id;
          });
        }
        else {
          _stops.remove(bin.number);
        }
       },
       initialSelection: null,
      dropdownMenuEntries: roomOptions,
    );

    const cellPadding = EdgeInsets.all(8.0);
    return TableRow(
      children: [
        Padding(
          padding: cellPadding,
          child: Text(
            bin.name,
            style: Theme.of(context).textTheme.labelLarge,
          )
        ),
        Padding(
          padding: cellPadding,
          child: roomMenu
        ),
      ]
    );
  }
}