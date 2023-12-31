import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/date_buttons.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/education.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Work_experience extends StatefulWidget {
  const Work_experience({super.key});

  @override
  State<Work_experience> createState() => _Work_experienceState();
}

class _Work_experienceState extends State<Work_experience> {
  //Controllers for textfields
  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save user data to work experience collection
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

  //Direct user to Add education bacground page
  void goToEduBg() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Education_background()));
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
        title: const Text('Add Work Experience'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 15,
            ),
            textField(
                controller: titleController,
                hintText: 'e.g Gardener',
                hideText: false,
                labelText: 'Title e.g Gardener',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            textField(
                controller: companyController,
                hintText: 'e.g Builders Warehouse',
                hideText: false,
                labelText: 'Company e.g Builders Warehouse',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 15,
            ),
            textField(
                controller: locationController,
                hintText: 'e.g Rhodespark',
                hideText: false,
                labelText: 'Location e.g Rhodespark',
                keyboardType: TextInputType.streetAddress),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: startShowDatePickerDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://pics.freeicons.io/uploads/icons/png/16784855481557740332-512.png',
                      height: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text('Select start date'),
                  ],
                ),
              ),
            ),
            Text(
              // ignore: unnecessary_null_comparison
              ' ${startDateTime == null ? '' : DateFormat('yyyy-MM-dd').format(startDateTime)}',
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: showDatePickerDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://pics.freeicons.io/uploads/icons/png/16784855481557740332-512.png',
                      height: 24.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text('Select end date'),
                  ],
                ),
              ),
            ),
            Text(
              ' ${dateTime == null ? '' : DateFormat('yyyy-MM-dd').format(dateTime)}',
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: descriptionController,
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
            const SizedBox(
              height: 15,
            ),
            Visibility(visible: false, child: Text(user.email!)),
            button(
                onTap: () async {
                  saveWorkExp(
                      titleController.text.trim(),
                      companyController.text.trim(),
                      locationController.text.trim(),
                      startDateTime.toString(),
                      dateTime.toString(),
                      descriptionController.text.trim());
                  goToEduBg();
                },
                text: 'Add your education background')
          ]),
        ),
      ),
    );
  }
}
