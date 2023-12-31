import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/date_buttons.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/home.dart';
import 'package:cp_final_project/pages/Freelancer/languages.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:cp_final_project/pages/Freelancer/skills.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Edit_Education_background extends StatefulWidget {
  const Edit_Education_background({super.key});

  @override
  State<Edit_Education_background> createState() =>
      _Edit_Education_backgroundState();
}

class _Edit_Education_backgroundState extends State<Edit_Education_background> {
  //Controllers for textfields
  final schoolController1 = TextEditingController();
  final degreeController1 = TextEditingController();
  final fieldController1 = TextEditingController();
  final descController1 = TextEditingController();

  //Get education background from database based on the current user ID and display the data in the textfields
  Future<void> _loadEduData() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Education_background')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      String school = snapshot.get('School');
      String degree = snapshot.get('Degree');
      String fieldOfStudy = snapshot.get('Field_of_study');
      String eduStartDate = snapshot.get('Start_Date');
      String eduEndDate = snapshot.get('End_Date');
      String eduDescription = snapshot.get('Description');

      schoolController1.text = school;
      degreeController1.text = degree;
      fieldController1.text = fieldOfStudy;
      startYear = DateTime.parse(eduStartDate);
      endYear = DateTime.parse(eduEndDate);
      descController1.text = eduDescription;
    } else {
      print('ERROR MATE!');
    }
  }

  //LOad the data on initialisation
  @override
  void initState() {
    super.initState();
    _loadEduData();
  }

  @override
  void dispose() {
    schoolController1.dispose();
    degreeController1.dispose();
    fieldController1.dispose();
    descController1.dispose();
    super.dispose();
  }

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save any changes made to the database collection when a user makes a change
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

  //Redirect user to the HomeScreen
  void goToProfile() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
        title: const Text('Edit Education Background'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Title field
            const SizedBox(
              height: 20,
            ),
            textField(
                controller: schoolController1,
                hintText: '',
                hideText: false,
                labelText: 'School',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),

            textField(
                controller: degreeController1,
                hintText: 'e.g Builders Warehouse',
                hideText: false,
                labelText: 'Degree',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),

            textField(
                controller: fieldController1,
                hintText: 'e.g Rhodespark',
                hideText: false,
                labelText: 'Field of study',
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
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: TextFormField(
                controller: descController1,
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
                      schoolController1.text,
                      degreeController1.text,
                      fieldController1.text,
                      startYear.toString(),
                      endYear.toString(),
                      descController1.text);
                  goToProfile();
                },
                text: 'Save')
          ]),
        ),
      ),
    );
  }
}
