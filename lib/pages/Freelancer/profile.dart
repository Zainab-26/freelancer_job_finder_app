// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/pages/Freelancer/edit_edu_bg.dart';
import 'package:cp_final_project/pages/Freelancer/edit_languages.dart';
import 'package:cp_final_project/pages/Freelancer/edit_skills.dart';
import 'package:cp_final_project/pages/Freelancer/edit_user_info.dart';
import 'package:cp_final_project/pages/Freelancer/edit_work_exp.dart';
import 'package:cp_final_project/pages/Freelancer/languages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bio.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String firstName = '';
  String lastName = '';
  String title1 = '';
  final user = FirebaseAuth.instance.currentUser!;
  //Current user ID
  final userId = FirebaseAuth.instance.currentUser?.uid;

  //Load data at initialisation
  @override
  void initState() {
    super.initState();
    loadProfileData();
    loadTitle();
  }

  //Load user's names based on current user ID
  Future<void> loadProfileData() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        firstName = snapshot.get('First_name');
        lastName = snapshot.get('Last_name');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Load user's title
  Future<void> loadTitle() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('Title')
        .doc(currentUser)
        .get();
    print('User snapshot1: ${snapshot1.data()}');

    if (snapshot1.exists && snapshot1.data() != null) {
      setState(() {
        title1 = snapshot1.get('Title');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2022/12/01/04/35/sunset-7628294_960_720.jpg',
                    height: 24.0,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text(title1, style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(
              '$firstName $lastName',
              style: GoogleFonts.robotoCondensed(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            button(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => edit_user_info(),
                  ));
                },
                text: 'Edit Profile'),
            Divider(),
            SizedBox(height: 15),
            ProfileListWidget(
                title: 'Skills',
                icon: Icons.co_present_sharp,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => editskills(),
                  ));
                }),
            Divider(),
            ProfileListWidget(
                title: 'Work Experience',
                icon: Icons.work_history,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Edit_Work_experience(
                      userId: user.toString(),
                    ),
                  ));
                }),
            Divider(),
            ProfileListWidget(
                title: 'Education Background',
                icon: Icons.cast_for_education,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Edit_Education_background(),
                  ));
                }),
            Divider(),
            ProfileListWidget(
                title: 'Languages',
                icon: Icons.supervised_user_circle,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => editLanguages(),
                  ));
                }),
            Divider(),
          ],
        ),
      )),
    );
  }
}

class ProfileListWidget extends StatelessWidget {
  const ProfileListWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

//Design for each profile tile
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodySmall?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
