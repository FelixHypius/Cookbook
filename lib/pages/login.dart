import 'package:cookbook/pages/register.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_title.dart';
import '../base_widgets/base_input_field.dart';
import '../util/custom_button_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      body: ListView(
        children: [
          BaseTitle(
            text: "Log in",
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          Container(
            height: screenHeight * 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: BaseInputField(
              icon: Icons.account_circle_outlined,
              hintText: "Enter email..",
              control: _emailController,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: BaseInputField(
              icon: Icons.key_outlined,
              hintText: "Enter password..",
              control: _passwordController,
              obscure: true,
              maxRows: 1,
            ),
          ),
          Row(
            children: [
              Checkbox(
                side: BorderSide(
                  color: MyColors.myWhite,
                  width: 3,
                ),
                checkColor: MyColors.myWhite,
                activeColor: MyColors.myRed,
                value: checked,
                onChanged: (bool? value) {
                  setState(() {
                    checked = value ?? false;
                  });
                },
              ),
              Text(
                'Remember me, please.. 🥹',
                style: CustomTextStyle(
                  size: 12.5,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 15, left: screenWidth * 0.25, right: screenWidth * 0.25),
            child: OutlinedButton(
              onPressed: login,
              style: CustomButtonStyle(backColor: MyColors.myWhite, borderColor: MyColors.myGrey),
              child: Text(
                "Log in!",
                style: CustomTextStyle(size: 15, colour: MyColors.myBlack),
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.1,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'If this is your first time cooking, please ',
                style: CustomTextStyle(
                  size: 12.5,
                ),
                children: [
                  TextSpan(
                    text: 'register!',
                    style: CustomTextStyle(
                      size: 12.5,
                      underlined: true,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      ),
                  ),
                ],
              ),
            ),
          ),
          // Forgot Password Section
          Center(
            child: TextButton(
              onPressed: resetPassword,  // Trigger password reset
              child: Text(
                "Forgot Password?",
                style: CustomTextStyle(size: 12.5, underlined: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember') ?? false;

    if (remember) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            "I don't remember you 😥. Please login using your credentials."
          ),
        );
      } else {
        if (EmailValidator.validate(email)) {
          try {
            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            await prefs.setString('email', email);
            checked
                ? await prefs.setBool('remember', true)
                : await prefs.setBool('remember', false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == "user-not-found") {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  'No user found for that email.'
                ),
              );
            } else if (e.code == "wrong-password") {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  'Incorrect password.'
                ),
              );
            } else if (e.code == "invalid-credential") {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  'Invalid credentials.'
                )
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              'Invalid email.'
            ),
          );
        }
      }
    }
  }

  Future<void> resetPassword() async {
    String email = _emailController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          'Please enter a valid email address.'
        ),
      );
    } else {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            'Password reset email sent!'
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              'No user found for that email.'
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              'Error: ${e.message}'
            ),
          );
        }
      }
    }
  }
}