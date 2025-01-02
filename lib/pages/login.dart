import 'package:cookbook/pages/register.dart';
import 'package:cookbook/pages/updates_info.dart';
import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_snackbar.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../base_widgets/base_button.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BaseTitle(
              text: "Log in",
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: BaseInputField(
                icon: Icons.account_circle_outlined,
                hintText: "Enter email..",
                control: _emailController,
                normalColour: MyColors.myWhite,
                fillColour: MyColors.myBlack,
                textColour: MyColors.myWhite,
                iconColour: MyColors.myWhite,
                focusedColour: MyColors.myBrightRed,
                hintColour: MyColors.myBrightGrey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: BaseInputField(
                icon: Icons.key_outlined,
                hintText: "Enter password..",
                control: _passwordController,
                obscure: true,
                maxRows: 1,
                normalColour: MyColors.myWhite,
                fillColour: MyColors.myBlack,
                textColour: MyColors.myWhite,
                iconColour: MyColors.myWhite,
                focusedColour: MyColors.myBrightRed,
                hintColour: MyColors.myBrightGrey,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Checkbox(
                    side: BorderSide(
                      color: MyColors.myWhite,
                      width: 2,
                    ),
                    checkColor: MyColors.myWhite,
                    activeColor: MyColors.myRed,
                    value: checked,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        checked = value ?? false;
                      });
                    },
                  ),
                ),
                Text(
                  'Remember me',
                  style: CustomTextStyle(
                    size: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight*0.035,
            ),
            BaseButton(
              func: login,
              text: Text('Log in!', style: CustomTextStyle(size: 15, tallness: 2), textAlign: TextAlign.center,),
              border: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)
              ),
              align: MainAxisAlignment.center,
              length: MainAxisSize.min,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            ),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Is this your first time cooking? Please ',
                  style: CustomTextStyle(
                    size: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'register!',
                      style: CustomTextStyle(
                        size: 12,
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
            SizedBox(
              height: 15,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Forgot your password? Click ',
                  style: CustomTextStyle(
                    size: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'here!',
                      style: CustomTextStyle(
                        size: 12,
                        underlined: true,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => resetPassword
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight*0.05,
            )
          ],
        ),
      )
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
              MaterialPageRoute(builder: (context) => UpdatesInfo()),
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