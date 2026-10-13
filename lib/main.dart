import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_project/firebase_options.dart';
import 'package:learning_project/routes/app_routes.dart';
import 'package:learning_project/services/notification_service.dart';
import 'package:learning_project/theams/app_theams.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('NotificationService initialization error: $e');
  }

  runApp(const RexBizApp());
}

class RexBizApp extends StatelessWidget {
  const RexBizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Value Market',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
