import 'package:flutter/material.dart';

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 100
              ),
              child: Image.asset("assets/images/TalariaLogoSquare.png"),
            ),
            Text(
              " Talaria",
              style: Theme.of(context).textTheme.headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Text(
              " Robotics",
              style: Theme.of(context).textTheme.headlineMedium!
                .copyWith(fontSize: 32),
            ),
          ],
        )
      ),
    );
  }
}