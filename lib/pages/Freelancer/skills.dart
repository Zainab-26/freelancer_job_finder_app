// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/bio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

//Handle user actions on skills on modal popup
class multiSelect extends StatefulWidget {
  final List<String> skills;
  const multiSelect({super.key, required this.skills});

  @override
  State<multiSelect> createState() => _multiSelectState();
}

class _multiSelectState extends State<multiSelect> {
  final List<String> selectedSkills = [];

  void itemChanged(String language, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSkills.add(language);
      } else {
        selectedSkills.remove(language);
      }
    });
  }

  //Close the modal popup if close button is clicked
  void cancel() {
    Navigator.pop(context);
  }

  //Add skills to list if submit button is clicked
  void submit() {
    Navigator.pop(context, selectedSkills);
  }

//Modal popup with all skills and buttons displayed
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select skills'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.skills
              .map((skill) => CheckboxListTile(
                    value: selectedSkills.contains(skill),
                    title: Text(skill),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => itemChanged(skill, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class skills extends StatefulWidget {
  const skills({Key? key}) : super(key: key);

  @override
  State<skills> createState() => _skillsState();
}

class _skillsState extends State<skills> {
  //List to store skills selected by user
  List<String> selectedSkills = [];

  //Show following skills as list to user for selection
  void showSkills() async {
    final List<String> skills = [
      'Babyproofing',
      'Car Washing',
      'Carpentry & Construction',
      'Cleaning',
      'Decoration',
      'Deep Clean',
      'Delivery',
      'Electrician',
      'Errands',
      'Event Staffing',
      'Executive Assistant',
      'Full-Service Help Moving',
      'Furniture Assembly',
      'Furniture Removal',
      'Interior Design',
      'Laundry and Ironing',
      'Lift & Shift Furniture',
      'Minor Home Repairs',
      'Mounting',
      'Moving Help',
      'Office Administration',
      'Organization',
      'Packing & Unpacking',
      'Painting',
      'Pet Sitting',
      'Plumbing',
      'Power Washing',
      'Project Coordination',
      'Rental Unit Management',
      'Room Measurement',
      'Sewing',
      'Shopping',
      'Smart Home Installation',
      'Waiting in Line',
      'Window Cleaning',
      'Yard Work'
    ];

    //Call showDialog function to display skills modal
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return multiSelect(skills: skills);
        });

    if (results != null) {
      setState(() {
        selectedSkills = results;
      });
    }
  }

  //Controllers
  final _skillsController = TextEditingController();
  final List<String> chipValues = [];

  //Add skills to chipValues list
  void addChip() {
    setState(() {
      chipValues.add(_skillsController.text.trim());
      _skillsController.clear();
    });
  }

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save skills selected by user to Skills collection in database
  saveSkills(String skill) {
    String userId = user.uid;
    FirebaseFirestore.instance
        .collection('Skills')
        .doc(userId)
        .set({'User_ID': userId, 'Skills': skill});
  }

  //Redirect user to add Bio page
  void goToBio() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => bio()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Add Skills'),
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
            child: Text('Great! Now tell the people your skills.',
                style: GoogleFonts.bebasNeue(fontSize: 48)),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 350,
            child: Text(
              'Your skills show clients what you can offer. Add any skills that are relevant to your profile.',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: showSkills, child: const Text('Select skills')),
          const Divider(
            height: 30,
          ),
          Wrap(
            children: selectedSkills
                .map((e) => Chip(
                      label: Text(e),
                      deleteButtonTooltipMessage: 'Remove',
                      onDeleted: () {
                        setState(() {
                          selectedSkills.remove(e);
                        });
                      },
                    ))
                .toList(),
            spacing: 8.0,
          ),
          SizedBox(height: 250),
          button(
              onTap: () async {
                saveSkills(selectedSkills.toString());
                goToBio();
              },
              text: 'Next: Add your bio')
        ]),
      )),
    );
  }
}
