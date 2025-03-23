import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ios_notification_task/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Request permissions only for iOS
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  //print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = constraints.maxWidth >= 1024
            ? Size(1440, 1024) // Desktop
            : constraints.maxWidth >= 600
                ? Size(768, 1024) // Tablet
                : Size(375, 812); // Mobile
        return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                title: 'Fast food',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                  useMaterial3: true,
                ),
                debugShowCheckedModeBanner: false,
                home: const HomeScreen(),
              );
            });
      },
    );
  }
}
