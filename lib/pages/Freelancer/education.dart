import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/date_buttons.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/languages.dart';
import 'package:cp_final_project/pages/Freelancer/skills.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Education_background extends StatefulWidget {
  const Education_background({super.key});

  @override
  State<Education_background> createState() => _Education_backgroundState();
}

class _Education_backgroundState extends State<Education_background> {
  //Controllers for textfields
  final schoolController = TextEditingController();
  final degreeController = TextEditingController();
  final fieldController = TextEditingController();
  final descController = TextEditingController();

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save user details to education background collection
  saveEduBg(String school, String degree, String fieldOfStudy, String startDate,
      String endDate, String description) {
    String userId = user.uid;

    FirebaseFirestore.instance
        .collection('Education_background')
        .doc(userId)
        .set({
      'User_ID': userId,
      'School': school,
      'Degree': degree,
      'Field_of_study': fieldOfStudy,
      'Start_Date': startDate,
      'End_Date': endDate,
      'Description': description
    });
  }

  //Redirect the user to select languages page
  void goToLanguages() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const selectLanguages()));
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
        endYear = value!;
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
        startYear = value!;
      });
    });
  }

  //variable for date
  DateTime endYear = DateTime.now();
  DateTime startYear = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Add Education background'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Title field
            const SizedBox(
              height: 15,
            ),
            textField(
                controller: schoolController,
                hintText: '',
                hideText: false,
                labelText: 'School',
                keyboardType: TextInputType.text),

            const SizedBox(
              height: 15,
            ),
            textField(
                controller: degreeController,
                hintText: '',
                hideText: false,
                labelText: 'Degree, if applicable',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 15,
            ),
            textField(
                controller: fieldController,
                hintText: '',
                hideText: false,
                labelText: 'Field Of Study',
                keyboardType: TextInputType.text),

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
              ' ${startYear == null ? '' : DateFormat('yyyy-MM-dd').format(startYear)}',
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
              ' ${endYear == null ? '' : DateFormat('yyyy-MM-dd').format(endYear)}',
            ),

            const SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: TextFormField(
                controller: descController,
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
                  saveEduBg(
                      schoolController.text,
                      degreeController.text,
                      fieldController.text,
                      startYear.toString(),
                      endYear.toString(),
                      descController.text);
                  goToLanguages();
                },
                text: 'Now, select your languages')
          ]),
        ),
      ),
    );
  }
}
