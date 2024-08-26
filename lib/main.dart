import 'package:flutter/material.dart';
import 'package:flutter_learning/database/db.dart';
import 'package:flutter_learning/navigation/app_route.dart';
import 'package:flutter_learning/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  await SportsDb().db;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRoutes mAppRoute = AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black, // for text/icons on white backgrounds
          background: Colors.white,
          onBackground: Colors.black, // for text/icons on white backgrounds
          surface: Colors.white,
          onSurface: Colors.black, // for text/icons on white surfaces
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (setting) => mAppRoute.router(setting)
    );
  }
}