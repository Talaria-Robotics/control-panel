import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class InTransitPage extends StatefulWidget {
  const InTransitPage({super.key});

  @override
  State<StatefulWidget> createState() => _InTransitPageState();
}

class _InTransitPageState extends State<InTransitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: TalariaHeader()
      ),
      body: const Text("In transit")
    );
  }
}
