// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/pages/Freelancer/home.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:cp_final_project/pages/Freelancer/skills.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

//Handle user actions on languages on modal popup
class multiSelect extends StatefulWidget {
  final List<String> languages;
  const multiSelect({super.key, required this.languages});

  @override
  State<multiSelect> createState() => _multiSelectState();
}

class _multiSelectState extends State<multiSelect> {
  final List<String> selectedLanguages = [];

  void itemChanged(String language, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedLanguages.add(language);
      } else {
        selectedLanguages.remove(language);
      }
    });
  }

  //Close the modal popup if close button is clicked
  void cancel() {
    Navigator.pop(context);
  }

  //Add languages to list if submit button is clicked
  void submit() {
    Navigator.pop(context, selectedLanguages);
  }

//Modal popup with all languages and buttons displayed
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select languages known'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.languages
              .map((language) => CheckboxListTile(
                    value: selectedLanguages.contains(language),
                    title: Text(language),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => itemChanged(language, isChecked!),
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

class editLanguages extends StatefulWidget {
  const editLanguages({super.key});

  @override
  State<editLanguages> createState() => _editLanguagesState();
}

class _editLanguagesState extends State<editLanguages> {
  //List to store languages selected by user
  List<String> selectedLanguages = [];

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Get languages selected by user when setting up their profile
  Future<void> getLanguages() async {
    String userId = user.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Languages')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      String langString = snapshot.get('Languages');

      langString = langString.substring(1, langString.length - 1);

      List<String> languages = langString.split(', ');
      setState(() {
        selectedLanguages = List<String>.from(languages);
      });
    }
  }

  //Call load function during initialisation
  @override
  void initState() {
    super.initState();
    getLanguages();
  }

  //Save languages selected by user to Languages collection in database
  saveLanguages(String languages) {
    String userId = user.uid;
    FirebaseFirestore.instance
        .collection('Languages')
        .doc(userId)
        .set({'User_ID': userId, 'Languages': languages});
  }

  //Redirect user to Home screen
  void goToProfile() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  //Show following languages as list to user for selection
  void showLanguages() async {
    final List<String> languages = [
      'Bemba',
      'Nyanja',
      'Tonga',
      'Lozi',
      'Kaonde',
      'Lunda',
      'Luvale',
      'Mambwe',
      'Chewa',
      'Tumbuka',
      'Lenje',
      'Soli',
      'Namwanga',
      'Chokwe',
      'Lamba',
      'Sala',
      'Subiya',
      'Toka Leya',
      'Mbunda',
      'English',
      'French',
      'Portuguese',
      'Swahili',
      'Afrikaans',
      'Hindi',
      'Mandarin',
      'Spanish',
      'German',
      'Italian'
    ];

    //Call showDialog method to display list of languages available to the user
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return multiSelect(languages: languages);
        });

    if (results != null) {
      setState(() {
        selectedLanguages = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Languages'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 350,
            child: Text('Awesome! Now, tell us what languages you speak.',
                style: GoogleFonts.bebasNeue(fontSize: 48)),
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            width: 350,
            child: Text(
              'Zambia is a country of many different cultures and people. In order to engage with a larger audience, select what languages suit you best.',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: showLanguages,
              child: const Text('Select languages spoken')),
          const Divider(
            height: 30,
          ),
          Wrap(
            children: selectedLanguages
                .map((e) => Chip(
                      label: Text(e),
                      deleteButtonTooltipMessage: 'Remove',
                      onDeleted: () {
                        setState(() {
                          selectedLanguages.remove(e);
                        });
                      },
                    ))
                .toList(),
            spacing: 8.0,
          ),
          const SizedBox(
            height: 15,
          ),
          button(
              onTap: () async {
                saveLanguages(selectedLanguages.toString());
                goToProfile();
              },
              text: 'Save')
        ],
      ))),
    );
  }
}
