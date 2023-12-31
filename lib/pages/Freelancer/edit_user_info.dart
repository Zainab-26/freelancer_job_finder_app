import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/home.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class edit_user_info extends StatefulWidget {
  const edit_user_info({super.key});

  @override
  State<edit_user_info> createState() => _edit_user_infoState();
}

class _edit_user_infoState extends State<edit_user_info> {
  //Controllers
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final editBioController = TextEditingController();
  final editTitleController = TextEditingController();

  //Load User data like, names, bio and title data from their respective collections and display in textfields
  Future<void> loadUserInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference usersColl = firestore.collection('Users');

    DocumentReference userDocRef = usersColl.doc(currentUser);

    DocumentSnapshot userSnapshot = await userDocRef.get();

    CollectionReference bioColl = firestore.collection('Bio');

    DocumentReference bioDocRef = bioColl.doc(currentUser);

    DocumentSnapshot bioSnapshot = await bioDocRef.get();

    CollectionReference titleColl = firestore.collection('Title');

    DocumentReference titlelDocRef = titleColl.doc(currentUser);

    DocumentSnapshot titleSnapshot = await titlelDocRef.get();

    if (userSnapshot.exists && bioSnapshot.exists && titleSnapshot.exists) {
      String editFirstName = userSnapshot.get('First_name');
      String editLastName = userSnapshot.get('Last_name');
      String editTitle = titleSnapshot.get('Title');
      String editBio = bioSnapshot.get('Bio');

      fNameController.text = editFirstName;
      lNameController.text = editLastName;
      editTitleController.text = editTitle;
      editBioController.text = editBio;
    }
  }

  //Current user
  String currentUser = FirebaseAuth.instance.currentUser!.uid;

  //Edit user data
  editUserInfo(String title, String fName, String lName, String bio) {
    FirebaseFirestore.instance
        .collection('Title')
        .doc(currentUser)
        .set({'Title': title});

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .set({'First_name': fName, 'Last_name': lName});

    FirebaseFirestore.instance
        .collection('Bio')
        .doc(currentUser)
        .set({'Bio': bio});
  }

  //Redirect user to Home Screen
  void goToProfile() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  //Call load function during initialisation
  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            textField(
                controller: editTitleController,
                hintText: 'Title',
                hideText: false,
                labelText: 'Title',
                keyboardType: TextInputType.text),
            const SizedBox(height: 40),
            textField(
                controller: fNameController,
                hintText: 'First Name',
                hideText: false,
                labelText: 'First Name',
                keyboardType: TextInputType.text),
            const SizedBox(height: 40),
            textField(
                controller: lNameController,
                hintText: 'Last Name',
                hideText: false,
                labelText: 'Last Name',
                keyboardType: TextInputType.text),
            const SizedBox(height: 40),
            textField(
                controller: editBioController,
                hintText: 'Bio',
                hideText: false,
                labelText: 'Bio',
                keyboardType: TextInputType.text),
            const SizedBox(height: 40),
            button(
                onTap: () async {
                  editUserInfo(editTitleController.text, fNameController.text,
                      lNameController.text, editBioController.text);
                  goToProfile();
                },
                text: 'Edit user data')
          ],
        ),
      )),
    );
  }
}
