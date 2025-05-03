import 'package:flutter/material.dart';
import 'package:terbangin/splashscreen.dart';
// import 'package:terbangin/home.dart';
// import 'package:terbangin/login2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Splashscreen(),
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const Splashscreen(),
      //   '/home': (context) => const Home(),
      //   '/login': (context) => Login2(),
      // },
    );
  }
}

