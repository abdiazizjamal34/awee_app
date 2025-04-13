import 'package:flutter/material.dart';
import 'screens/auth/login_secreen.dart';

void main() {
  runApp(MyApp());
}

// const mixedColor = Color.lerp(Colors.redAccent, Colors.purple, 0.5)

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmallBiz Toolkit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.lerp(
          const Color.fromARGB(255, 20, 35, 65),
          const Color.fromARGB(255, 30, 16, 32),
          0.5,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.lerp(
            const Color.fromARGB(255, 112, 127, 156),
            const Color.fromARGB(255, 182, 108, 192),
            0.5,
          ),

          titleTextStyle: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        textTheme: TextTheme(
          labelMedium: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          labelSmall: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          labelLarge: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          titleLarge: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          titleMedium: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          titleSmall: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          displayLarge: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          bodyLarge: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
          bodyMedium: TextStyle(
            color: Color.lerp(
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255),
              0.5,
            ),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
