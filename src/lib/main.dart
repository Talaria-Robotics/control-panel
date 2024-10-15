import 'package:control_panel/api/mock_navigator_api.dart';
import 'package:control_panel/api/navigator_api.dart';
import 'package:control_panel/colors.dart';
import 'package:control_panel/routes/first_route.dart';
import 'package:control_panel/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  initServices();
  runApp(const MyApp());
}

void initServices() {
  NavigatorApi.instance = MockNavigatorApi();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TalariaStrings.teamName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: TalariaColors.maroon,
          brightness: Brightness.light,
          contrastLevel: 1.0,
        ),
        fontFamily: GoogleFonts.gabarito().fontFamily,
        useMaterial3: true,
      ),
      home: const FirstRoute(),
    );
  }
}
