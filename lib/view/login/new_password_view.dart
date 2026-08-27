import 'package:cookin/common/auth_service.dart';
import 'package:cookin/common/color_extension.dart';
import 'package:cookin/common_widget/round_button.dart';
import 'package:cookin/view/login/login_view.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_textfield.dart';

class NewPasswordView extends StatefulWidget {
  final String email;

  const NewPasswordView({super.key, required this.email});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                "New Password",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please enter your new password ",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              RoundTextfield(
                hinText: "New Password",
                controller: txtPassword,
              ),
              const SizedBox(
                height: 60,
              ),
              RoundTextfield(
                hinText: "Confirm Password",
                controller: txtConfirmPassword,
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: "Next",
                  onPressed: () {
                    final error = AuthService.instance.resetPassword(
                      email: widget.email,
                      newPassword: txtPassword.text,
                      confirmPassword: txtConfirmPassword.text,
                    );
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
