// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/main.dart';
import 'package:cp_final_project/pages/Freelancer/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  //Controllers for textfields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userTypeController = TextEditingController();

  //Dropdown menu options
  final List<String> userType = [
    'Freelancer',
    'Client',
  ];
  String selectedType = 'Freelancer';

  //Sign up method
  void signUp() async {
    //Show loader
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        register(
            emailController.text.trim(),
            passwordController.text.trim(),
            firstNameController.text.trim(),
            lastNameController.text.trim(),
            selectedType);
      } else if (passwordController.text == confirmPasswordController.text) {
        matchPasswords();
      }

      //Get rid of loader
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}');
      //Get rid of loader
      Navigator.pop(context);

      //Check if user exists
      if (e.code == 'weak-password') {
        weakPassword();

        print('ERRORS' + e.code);
      } else if (e.code == 'email-already-in-use') {
        emailAlreadyExists();
      }

      //Checks if password matches
      else {
        print('ERRORS' + e.code);
        error();
      }
    }
  }

  goToTitle() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const addTitle()),
    );
  }

  Future<UserCredential> register(String email, String password, String fName,
      String lName, String userType) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    //Save user data to Firestore database
    String userId = userCredential.user!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .set({'User_ID': userId, 'First_name': fName, 'Last_name': lName});

    return userCredential;
  }

  void weakPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('The password provided must have at least 6 characters.'),
        );
      },
    );
  }

  void emailAlreadyExists() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
              'The email provided is already is use, please try logging in'),
        );
      },
    );
  }

  void error() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('An error occured, please try again later.'),
        );
      },
    );
  }

  void matchPasswords() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('The passwords must match, please try again.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        // ignore: prefer_const_literals_to_create_immutables
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome!', style: GoogleFonts.bebasNeue(fontSize: 52)),
            SizedBox(height: 15),
            Text(
              'Let\'s create an account for you :)',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 45),

            //First name textfield
            textField(
                controller: firstNameController,
                hintText: 'First Name',
                hideText: false,
                labelText: 'First Name',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Last name textfield
            textField(
                controller: lastNameController,
                hintText: 'Last Name',
                hideText: false,
                labelText: 'Last Name',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Email textfield
            textField(
                controller: emailController,
                hintText: 'Username',
                hideText: false,
                labelText: 'Email',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Password textfield
            textField(
                controller: passwordController,
                hintText: 'Password',
                hideText: true,
                labelText: 'Password',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            textField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                hideText: true,
                labelText: 'Confirm Password',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Sign up button
            button(
              text: 'Sign Up',
              onTap: () async {
                signUp();
                goToTitle();
              },
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    ' Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ]),
        ),
      )),
    );
  }
}
