import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'package:control_panel/routes/in_transit_page.dart';
import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  const PlanRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanRouteState();
}

enum _PlanRouteStatus {
  loading,
  binConfig,
  confirmation,
}

class _PlanRouteState extends State<PlanRoute> {
  _PlanRouteStatus _status = _PlanRouteStatus.loading;
  PossibleMailRouteInfo? _route;
  final Map<int, String> _stops = {};

  MailRouteRoom _getRoom(String id) {
    return _route!.rooms.firstWhere((r) => r.id == id);
  }

  MailBin _getBin(int number) {
    return _route!.bins.firstWhere((b) => b.number == number);
  }

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    final routeInfo = await NavigatorApi.instance.getPossibleRouteInfo();
    setState(() {
      _status = _PlanRouteStatus.binConfig;
      _route = routeInfo;
    });
  }

  Future<void> next() async {
    setState(() {
      _status = _PlanRouteStatus.confirmation;
    });
  }

  Future<void> confirm() async {
    setState(() {
      _status = _PlanRouteStatus.loading;
    });

    final requestedRoute = RequestedMailRoute()
      ..stops = _stops;
    await NavigatorApi.instance.setRoute(requestedRoute);

    // We've told the navigator what our requested
    // route is. Navigate to the "in-transit" page.
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => const InTransitPage()));
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    Widget? fab;

    if (_status == _PlanRouteStatus.binConfig) {
      (body, fab) = buildBinConfig(context);
    }
    else if (_status == _PlanRouteStatus.confirmation) {
      body = buildConfirmation(context);
    }
    else {
      body = buildLoading(context);
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: TalariaHeader()
      ),
      body: body,
      floatingActionButton: fab,
    );
  }

  Widget buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  (Widget, Widget) buildBinConfig(BuildContext context) {
    final stopRows = <TableRow>[];
    for (final bin in _route!.bins) {
      stopRows.add(buildRow(context, bin));
    }

    final stopsView = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {0: IntrinsicColumnWidth()},
      children: stopRows,
    );

    return (
      SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: stopsView
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton.filled(
            onPressed: _stops.isNotEmpty ? next : null,
            // child: const Text("Next"),
            icon: const Icon(Icons.navigate_next)
          )
        ],
      )
    );
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

    final initialRoomId = _stops[bin.number];

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
      initialSelection: initialRoomId != null ? _getRoom(initialRoomId) : null,
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

  Widget buildConfirmation(BuildContext context) {
    final routeSummary = _stops.entries
      .map((entry) => "${_getBin(entry.key).name}  →  ${_getRoom(entry.value).name}")
      .join("\r\n");

    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please confirm delivery information",
              style: Theme.of(context).textTheme.titleLarge
            ),
            Text(
              "The route cannot be changed once delivery has begun.",
              style: Theme.of(context).textTheme.labelSmall
            ),
            const SizedBox(height: 20),
            Text(
              routeSummary,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      _status = _PlanRouteStatus.binConfig;
                    });
                  },
                  icon: const Icon(Icons.navigate_before)
                ),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: confirm,
                  child: const Text("Start Delivery")
                ),
              ],
            ),
            
          ],
        )
      ),
    );
  }
}