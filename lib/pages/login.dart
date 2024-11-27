import 'package:cookbook/pages/register.dart';
import 'package:cookbook/util/colors.dart';
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

class LoginPage extends StatefulWidget{

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
            height: screenHeight*0.1,
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
                    width: 3
                ),
                checkColor: MyColors.myWhite,
                activeColor: MyColors.myRed,
                value: checked,
                onChanged: (bool? value){
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
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 15, left: screenWidth*0.25, right: screenWidth*0.25),
            child: OutlinedButton(
              onPressed: login,
              style: CustomButtonStyle(backColor: MyColors.myWhite, borderColor: MyColors.myGrey,),
              child: Text(
                "Log in!",
                style: CustomTextStyle(size: 15, colour: MyColors.myBlack),
              ),
            ),
          ),
          Container(
            height: screenHeight*0.1,
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
                          underlined: true
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()
                        )
                      ),
                    )
                  ]
              ),
            ),
          )
        ],
      )
    );
  }

  Future<void> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember') ?? false;

    if (remember) {
      // Navigate to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email.isEmpty || password.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("I don't remember you 😥. Please login using your credentials."),
          ),
        );
      } else {
        if (EmailValidator.validate(email)) {
          try {
            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );

            // Login successful
            await prefs.setString('email', email);
            checked ? await prefs.setBool('remember', true) : await prefs.setBool('remember', false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == "user-not-found") {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No user found for that email."),)
              );
            } else if (e.code == "wrong-password") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Incorrect password.")),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email.")),
          );
        }
      }
    }
  }
}
