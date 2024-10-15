import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/api/navigator_models.dart';
import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  const PlanRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  Iterable<MailRouteRoom>? _rooms;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    final routeInfo = await NavigatorApi.instance.getPossibleRouteInfo();
    setState(() {
      _rooms = routeInfo.rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;

    if (_rooms == null) {
      content = const CircularProgressIndicator();
    }
    else {
      final dropdownOptions = <DropdownMenuEntry<MailRouteRoom>>[];
      for (final room in _rooms!) {
        final dropdownOption = DropdownMenuEntry(
          value: room,
          label: room.name,
        );
        dropdownOptions.add(dropdownOption);
      }
      content = DropdownMenu(
        onSelected: (value) { print(value?.name ?? "{null}"); },
        dropdownMenuEntries: dropdownOptions,
      );
    }
    
    return Material(
      child: Center(
        child: content
      ),
    );
  }
}