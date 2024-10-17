import 'package:flutter/material.dart';

class TalariaHeader extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;

  const TalariaHeader({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Image.asset("assets/images/TalariaLogoSquare.png",
          fit: BoxFit.fitHeight,
          height: 50,
        ),
        Text(
          " Talaria",
          style: Theme.of(context).textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        Text(
          " Robotics",
          style: Theme.of(context).textTheme.headlineMedium!
            .copyWith(fontSize: 28),
        ),
      ]
    );
  }
}