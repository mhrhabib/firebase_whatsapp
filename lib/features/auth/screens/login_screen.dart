import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_firebase/common/widgets/custom_button.dart';
import 'package:whats_app_firebase/features/auth/controller/auth_controller.dart';
import 'package:whats_app_firebase/features/auth/repository/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = 'login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country? _country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _country = country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    print("hello");
    if (_country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(context, "+${_country!.phoneCode}$phoneNumber");
    } else {
      print("fill out hte form");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("Enter your phone number"),
      ),
      body: Column(
        children: [
          SizedBox(height: size.height / 9),
          const Text("What's app will need to verify your phone number"),
          TextButton(onPressed: () => pickCountry(), child: const Text("Pick Country")),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                if (_country != null) Text("+${_country!.phoneCode}"),
                const SizedBox(width: 8),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'phone number',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height / 3),
          SizedBox(
              width: size.width * .34,
              child: CustomButton(
                  text: 'Next',
                  onPressed: () {
                    ref.read(authRepoSitoryProvider).signInWithGoogle(context);
                  })),
        ],
      ),
    );
  }
}
