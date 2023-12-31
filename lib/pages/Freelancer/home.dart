import 'package:cp_final_project/pages/Freelancer/chats.dart';
import 'package:cp_final_project/pages/Freelancer/chats_screen.dart';
import 'package:cp_final_project/pages/Freelancer/explore.dart';
import 'package:cp_final_project/pages/Freelancer/profile.dart';
import 'package:cp_final_project/pages/Freelancer/view_reviews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  PageController pageController = PageController();
  late String currentUser;

  // Log user out
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  void onTap(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      explore(),
      myReviews(),
      ChatListScreen(currentUserId: currentUser),
      profile(),
    ];

    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.rate_review), label: 'My reviews'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.deepPurple,
        onTap: onTap,
      ),
    );
  }
}
