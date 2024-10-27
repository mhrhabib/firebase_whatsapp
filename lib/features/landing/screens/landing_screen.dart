import 'package:flutter/material.dart';
import 'package:whats_app_firebase/colors.dart';
import 'package:whats_app_firebase/common/widgets/custom_button.dart';
import 'package:whats_app_firebase/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Welcome to what's app",
            style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: size.height / 9),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: tabColor)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/backgroundImage.png",
                height: 340,
                width: 340,
              ),
            ),
          ),
          SizedBox(height: size.height / 9),
          const Text(
            "Read our privacy policy. Tap 'Agree and continue' to  accept the terms of services",
            style: TextStyle(
              color: grayColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.75,
            child: CustomButton(
              text: "Agree and Continue",
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
            ),
          ),
        ],
      )),
    );
  }
}
