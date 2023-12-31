// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/home.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class bio extends StatefulWidget {
  const bio({Key? key}) : super(key: key);

  @override
  State<bio> createState() => _bioState();
}

class _bioState extends State<bio> {
  //Controllers
  final _bioController = TextEditingController();

  //Current user ID
  final user = FirebaseAuth.instance.currentUser!;

  //Save bio entered to Bio collection
  saveBio(String bio) {
    String userId = user.uid;
    FirebaseFirestore.instance
        .collection('Bio')
        .doc(userId)
        .set({'User_ID': userId, 'Bio': bio});
  }

  //Redirect user to Home page (Explore page)
  void goToProfile() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Write your bio'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Form for adding bio
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 350,
            child: Text('Write a bio to help people get to know you!',
                style: GoogleFonts.bebasNeue(fontSize: 48)),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            child: Text(
              'Give people a quick and clear idea of what you\'re good at. List your strengths and skills in short paragraphs or bullet points. You can always edit this later to make it better.',
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
            padding: const EdgeInsets.all(25.0),
            child: TextFormField(
              maxLines: null,
              controller: _bioController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Enter bio',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
          SizedBox(height: 200),
          button(
              onTap: () async {
                saveBio(_bioController.text);
                goToProfile();
              },
              text: 'Great! All done!')
        ]),
      )),
    );
  }
}
