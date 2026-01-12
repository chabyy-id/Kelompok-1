import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'page/main_page.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(

      //ddta lihat di file google-services.json
        apiKey: "AIzaSyCJ2uuBhuVb6uTspttsqZv7Wckc9F9vPmo", //current_key
        appId: "1:369326613350:android:e4d5b021523f25e7d6dea7", //mobilesdk_app_id
        messagingSenderId: "369326613350", //project_number
        projectId: "absensi-bafd5"), //project_id
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
        ),

        cardTheme: const CardThemeData(
          surfaceTintColor: Colors.white,
          color: Colors.white,
        ),

        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),

      home: const MainPage(),
    );
  }
}