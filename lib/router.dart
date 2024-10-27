import 'package:flutter/material.dart';
import 'package:whats_app_firebase/features/auth/screens/login_screen.dart';

import 'features/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OtpScreen(
                verificationId: verificationId,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Error"),
          ),
        ),
      );
  }
}
