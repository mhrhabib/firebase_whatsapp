import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = 'otp-screen';
  const OtpScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otp"),
      ),
    );
  }
}
