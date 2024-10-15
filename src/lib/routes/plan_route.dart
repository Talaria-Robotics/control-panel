import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  const PlanRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  List<String>? _roomOptions;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (_roomOptions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final dropdownOptions = <DropdownMenuEntry<String>>[];
    for (final option in _roomOptions!) {
      final dropdownOption = DropdownMenuEntry<String>(
        value: option,
        label: "Option $option",
      );
      dropdownOptions.add(dropdownOption);
    }

    return Material(
      child: Center(
        child: DropdownMenu<String>(
          onSelected: (String? value) { print(value); },
          dropdownMenuEntries: dropdownOptions,
        )
      ),
    );
  }
}