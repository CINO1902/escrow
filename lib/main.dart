// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'core/approuter.dart';
import 'core/service/locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  setup();
  await dotenv.load(fileName: "assets/config/.env");
  runApp(const ProviderScope(child: MyApp()));
  // ← you can leave this here, but see below for an even safer pattern
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Wait until after the first frame, then remove the splash:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'H Smart',

      routerConfig: AppRouter.router,
      builder: FlutterSmartDialog.init(),
    );
  }
}
