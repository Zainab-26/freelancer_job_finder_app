import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/pages/Freelancer/add_bid.dart';
import 'package:cp_final_project/pages/Freelancer/chats_screen.dart';
import 'package:cp_final_project/pages/Freelancer/view_all_bids.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatefulWidget {
  final DocumentSnapshot jobSnapshot;

  const JobDetailsPage({Key? key, required this.jobSnapshot}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  //Declaring variables
  late String jobTitle;
  late String jobType;
  late String jobDescription;
  late String appointmentDate;
  late String appointmentTime;
  late String appointmentId;
  late String clientId;
  late String userId;
  bool hasPlacedBid = false;
  late String bidAmount = '';
  late String bidDuration = '';

  //Functions called at initialisation
  @override
  void initState() {
    super.initState();
    loadJobData();
    getUserId();
    checkBidStatus();
  }

  //Get current user ID
  getUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    userId = currentUser.uid;
  }

  //Get job details of specific job posted by client
  Future<void> loadJobData() async {
    final snapshot = widget.jobSnapshot;
    jobTitle = snapshot['Job_title'];
    jobType = snapshot['Job_type'];
    jobDescription = snapshot['Appointment_address'];
    appointmentDate = snapshot['Appointment_date'];
    appointmentTime = snapshot['Appointment_time'];
    appointmentId = snapshot['Appointment_ID'];
    clientId = snapshot['User_ID'];
  }

  //Check if current user has posted bid or not
  Future<void> checkBidStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Bids')
        .where('User_ID', isEqualTo: user?.uid)
        .where('Appointment_ID', isEqualTo: appointmentId)
        .get();

    if (mounted) {
      setState(() {
        hasPlacedBid = querySnapshot.docs.isNotEmpty;

        //Display bid details if bid has been placed
        if (hasPlacedBid) {
          final bid = querySnapshot.docs.first.data();
          bidAmount = bid['Amount'];
          bidDuration = bid['Estimated_duration'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(jobTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(jobDescription, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Date:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointmentDate, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Time:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointmentTime, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Job Type:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(jobType, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Your bid:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(bidAmount, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Estimated Duration:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(bidDuration, style: const TextStyle(fontSize: 16)),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  //Disable 'Place bid' button if bid has been placed by freelancer
                  onPressed: hasPlacedBid
                      ? null
                      : () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => placeBid(
                              appointId: appointmentId,
                            ),
                          ));
                        },
                  child: const Text('Place bid'),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        currentUserId: userId,
                        otherUserId: clientId,
                      ),
                    ));
                  },
                  child: const Text('Start chat'),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => viewBids(
                        appointId: appointmentId,
                      ),
                    ));
                  },
                  child: const Text('View all bids'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
