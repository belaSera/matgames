// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathsgames/src/core/app_constant.dart';
import 'package:mathsgames/src/core/app_theme.dart';
import 'package:mathsgames/src/core/app_routes.dart';
import 'package:mathsgames/src/ui/app/theme_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final String fontFamily = "Montserrat";
  // final FirebaseAnalytics firebaseAnalytics;

  const MyApp({
    // required this.firebaseAnalytics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<ThemeProvider>(
        builder: (context, ThemeProvider provider, child) {
      return MaterialApp(
        title: 'Math Games',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        initialRoute: KeyUtil.splash,
        routes: appRoutes,
        navigatorObservers: [],
      );
    });
  }
}
