// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/date_buttons.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/home.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Edit_Work_experience extends StatefulWidget {
  final String userId;
  const Edit_Work_experience({required this.userId, Key? key})
      : super(key: key);

  @override
  State<Edit_Work_experience> createState() => _Edit_Work_experienceState();
}

class _Edit_Work_experienceState extends State<Edit_Work_experience> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name = '';

  //Controllers for textfields
  TextEditingController titleController1 = TextEditingController();
  TextEditingController companyController1 = TextEditingController();
  TextEditingController locationController1 = TextEditingController();
  TextEditingController descriptionController1 = TextEditingController();

  //Load data from Work experience collection and display in textfields
  Future<void> _loadUserData() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Work_experience')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      String company = snapshot.get('Company');
      String title = snapshot.get('Title');
      String location = snapshot.get('Location');
      String startDate = snapshot.get('Start_Date');
      String endDate = snapshot.get('End_Date');
      String description = snapshot.get('Description');

      titleController1.text = title;
      companyController1.text = company;
      locationController1.text = location;
      startDateTime = DateTime.parse(startDate);
      dateTime = DateTime.parse(endDate);
      descriptionController1.text = description;
    } else {
      print('ERROR MATE!');
    }
  }

  //Load data during initialisation
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    titleController1.dispose();
    companyController1.dispose();
    locationController1.dispose();
    descriptionController1.dispose();
    super.dispose();
  }

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save updated details to Work experience collection
  saveWorkExp(String title, String company, String location, String startDate,
      String endDate, String description) {
    String userId = user.uid;

    FirebaseFirestore.instance.collection('Work_experience').doc(userId).set({
      'User_ID': userId,
      'Title': title,
      'Company': company,
      'Location': location,
      'Start_Date': startDate,
      'End_Date': endDate,
      'Description': description
    });
  }

  //Redirect user to Home screen
  void goToProfile() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  //Method for date picker
  void showDatePickerDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(30000))
        .then((value) {
      setState(() {
        dateTime = value!;
      });
    });
  }

  //Method for date picker
  void startShowDatePickerDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(30000))
        .then((value) {
      setState(() {
        startDateTime = value!;
      });
    });
  }

  //variable for date
  DateTime dateTime = DateTime.now();
  DateTime startDateTime = DateTime.now();

  //Log user out
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Edit Work Experience'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Title field
            SizedBox(
              height: 20,
            ),

            textField(
                controller: titleController1,
                hintText: '',
                hideText: false,
                labelText: 'Title',
                keyboardType: TextInputType.text),
            SizedBox(
              height: 20,
            ),

            textField(
                controller: companyController1,
                hintText: 'e.g Builders Warehouse',
                hideText: false,
                labelText: 'Company e.g Builders Warehouse',
                keyboardType: TextInputType.text),
            SizedBox(
              height: 20,
            ),

            textField(
                controller: locationController1,
                hintText: 'e.g Rhodespark',
                hideText: false,
                labelText: 'Location e.g Rhodespark',
                keyboardType: TextInputType.text),

            Padding(
              padding: EdgeInsets.all(25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.all(15),
                ),
                onPressed: startShowDatePickerDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://pics.freeicons.io/uploads/icons/png/16784855481557740332-512.png',
                      height: 24.0,
                    ),
                    SizedBox(width: 10.0),
                    Text('Select start date'),
                  ],
                ),
              ),
            ),

            Text(
              ' ${startDateTime == null ? '' : DateFormat('yyyy-MM-dd').format(startDateTime)}',
            ),

            Padding(
              padding: EdgeInsets.all(25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.all(15),
                ),
                onPressed: showDatePickerDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://pics.freeicons.io/uploads/icons/png/16784855481557740332-512.png',
                      height: 24.0,
                    ),
                    SizedBox(width: 10.0),
                    Text('Select end date'),
                  ],
                ),
              ),
            ),

            Text(
              ' ${dateTime == null ? '' : DateFormat('yyyy-MM-dd').format(dateTime)}',
            ),

            SizedBox(
              height: 15,
            ),

            Padding(
              padding: EdgeInsets.all(25),
              child: TextField(
                controller: descriptionController1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Visibility(visible: false, child: Text(user.email!)),

            button(
                onTap: () async {
                  saveWorkExp(
                      titleController1.text.trim(),
                      companyController1.text.trim(),
                      locationController1.text.trim(),
                      startDateTime.toString(),
                      dateTime.toString(),
                      descriptionController1.text.trim());
                  goToProfile();
                },
                text: 'Save')
          ]),
        ),
      ),
    );
  }
}
