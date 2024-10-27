import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_firebase/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          SizedBox(width: size.width * .34, child: CustomButton(text: 'Next', onPressed: () {})),
        ],
      ),
    );
  }
}
