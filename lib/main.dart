import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:gemini_bot/ui/view/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      home: HomeView(),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   fontFamily: 'Koho',
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
        fontFamily: 'Koho',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
