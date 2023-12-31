// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/pages/Freelancer/index.dart';
import 'package:cp_final_project/pages/Freelancer/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/button.dart';

class userType extends StatefulWidget {
  const userType({super.key});

  @override
  State<userType> createState() => _userTypeState();
}

class _userTypeState extends State<userType> {
  final List<String> userType = [
    'Freelancer',
    'Client',
  ];
  String selectedType = 'Freelancer';

  final user = FirebaseAuth.instance.currentUser!;

  saveUserType(String userType) {
    //Save user data to Firestore database
    String userId = user.uid;
    FirebaseFirestore.instance
        .collection('User_Type')
        .doc(userId)
        .set({'User_ID': userId, 'User_type': userType});
  }

  void goToTitle() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addTitle()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.portrait_sharp),
          title: Text('Type of User'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 350,
                  child: Text('Client or Freelancer?',
                      style: GoogleFonts.bebasNeue(fontSize: 48)),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 350,
                  child: Text(
                    'Tell us whether you want to use our platform to work as a freelancer or find skilled individuals that are suitable to complete the job required.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                    value: selectedType,
                    onChanged: (String? changedValue) {
                      if (changedValue != null) {
                        setState(() {
                          selectedType = changedValue;
                        });
                      }
                    },
                    items: userType
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                button(
                    onTap: () async {
                      await saveUserType(selectedType);
                      goToTitle();
                    },
                    text: 'Next: Enter your title'),
              ],
            ),
          ),
        ));
  }
}
