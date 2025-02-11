import 'package:cookbook/util/colors.dart';
import 'package:cookbook/util/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base_widgets/base_button.dart';
import '../base_widgets/base_scaffold.dart';
import '../base_widgets/base_title.dart';
import '../base_widgets/base_input_field.dart';
import '../util/custom_snackbar.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            BaseTitle(
              text: "Register",
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            Container(
              height: screenHeight * 0.1,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: BaseInputField(
                icon: Icons.email_outlined,
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
            Padding(
              padding: EdgeInsets.all(10),
              child: BaseInputField(
                icon: Icons.key_outlined,
                hintText: "Re-enter password..",
                control: _repeatPasswordController,
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
            SizedBox(
              height: screenHeight*0.05,
            ),
            BaseButton(
              func: register,
              text: Text('Register!', style: CustomTextStyle(size: 15, tallness: 2), textAlign: TextAlign.center,),
              border: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)
              ),
              align: MainAxisAlignment.center,
              length: MainAxisSize.min,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            ),
          ],
        ),
      )
    );
  }

  Future<void> register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String repeatPassword = _repeatPasswordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty) {
      if (password == repeatPassword) {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          /* firebase.auth().onAuthStateChanged(function(user) {
             user.sendEmailVerification();
             });
          */
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } on FirebaseAuthException catch (e) {
          String message = "Registration failed. ${e.code}";
          if (e.code == 'email-already-in-use') {
            message = "An account already exists for that email.";
          } else if (e.code == 'weak-password') {
            message = "The password provided is too weak.";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(message),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            'Passwords do not match.'
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          'All fields are required.'
        ),
      );
    }
  }
}
