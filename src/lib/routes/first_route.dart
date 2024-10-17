import 'package:control_panel/routes/plan_route.dart';
import 'package:control_panel/widgets/talaria_header.dart';
import 'package:flutter/material.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TalariaHeader(mainAxisAlignment: MainAxisAlignment.center),
            const SizedBox(height: 5),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const PlanRoute()));
              },
              child: const Text("Get Started")
            ),
          ],
        )
      ),
    );
  }
}