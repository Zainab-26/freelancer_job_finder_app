// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/work_experience.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class addTitle extends StatefulWidget {
  const addTitle({Key? key}) : super(key: key);

  @override
  State<addTitle> createState() => _addTitleState();
}

class _addTitleState extends State<addTitle> {
  //Controllers
  final _titleController = TextEditingController();

  //Current user
  final user = FirebaseAuth.instance.currentUser;
  String? userId;

  //Save title entred to Title collection in the database
  saveTitle(String title) {
    if (user != null) {
      userId = user!.uid;
      // Proceed with using userId
    } else {
      // Handle the case when user is null
      // userId will remain null in this case
    }
    FirebaseFirestore.instance
        .collection('Title')
        .doc(userId)
        .set({'User_ID': userId, 'Title': title});
  }

  //Direct user to work experience page
  void goToWorkExp() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Work_experience()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Create Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 350,
            child: Text('Add a title to let people know what you do!',
                style: GoogleFonts.bebasNeue(fontSize: 48)),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            child: Text(
              'Your first impression is crucial, so use it wisely! Describe your expertise in a way that highlights your unique style and personality to stand out from the rest.',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          textField(
              controller: _titleController,
              hintText: 'Example: Gardener | Brick layer',
              hideText: false,
              labelText: 'Example: Gardener | Brick layer',
              keyboardType: TextInputType.text),
          SizedBox(height: 250),
          button(
              onTap: () async {
                await saveTitle(_titleController.text.trim());
                goToWorkExp();
              },
              text: 'Next: Add your work experience')
        ]),
      )),
    );
  }
}
