// import 'package:awee/screens/comingson/comingSon.dart';
// import 'package:awee/screens/dashbord/dashbord_screen.dart';
import 'package:awee/screens/auth/presentation/bloc/login_screen.dart';
import 'package:awee/screens/dashbord/presentation/dashboard_screens.dart';
import 'package:awee/screens/products/prodect_screen.dart';
import 'package:awee/them/them.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'screens/auth/login_secreen.dart';
// import 'package:awee/screens/products/prodect_screen.dart';

void main() {
  // AwesomeNotifications().initialize(
  //   null, // icon for Android notification (set later if needed)
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic Notifications',
  //       channelDescription: 'Notification for welcome back message',
  //       defaultColor: Colors.teal,
  //       importance: NotificationImportance.High,
  //       channelShowBadge: true,
  //     ),
  //   ],
  // );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //   void showNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     channelDescription: 'your_channel_description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Notification ID
  //     'Hello 👋',
  //     'This is a local notification!',
  //     platformChannelSpecifics,
  //   );
  // }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color.lerp(
        const Color.fromARGB(255, 20, 35, 65),
        const Color.fromARGB(255, 30, 16, 32),
        0.5,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 112, 127, 156),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color.fromARGB(255, 98, 121, 172),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ).copyWith(
        secondary: Colors.purpleAccent,
        brightness: Brightness.dark, // ✅ Explicit match!
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ).copyWith(
        secondary: Colors.indigoAccent,
        brightness: Brightness.light, // ✅ Explicit match!
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SmallBiz Toolkit',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: const LoginScreen(),
    );
  }
}
