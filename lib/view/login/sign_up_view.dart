import 'package:cookin/common/color_extention.dart/color_extension.dart';
import 'package:cookin/common_widget/round_button.dart';
//import 'package:cookin/common_widget/round_button.dart';
//import 'package:cookin/common_widget/round_icon_button.dart';
import 'package:cookin/view/login/login_view.dart';
import 'package:cookin/view/login/otp_view.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _LoginViewState();
}

class _LoginViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //  var media = MediaQuery.of(context).size;
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
                "SignUp",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Add your details to Sign Up",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Name",
                controller: txtName,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Phone No",
                controller: txtMobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Address",
                controller: txtAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              RoundTextfield(
                hintText: " Password",
                controller: txtPassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundTextfield(
                hintText: "Confirm Password",
                controller: txtConfirmPassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                  title: "Sign Up",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OtpView(),
                      ),
                    );
                  }),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Already have an Account?",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
