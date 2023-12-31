import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class viewBids extends StatefulWidget {
  final String appointId;

  const viewBids({super.key, required this.appointId});

  @override
  State<viewBids> createState() => _viewBidsState();
}

class _viewBidsState extends State<viewBids> {
  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Get all bids depending on appointment id
  Stream<QuerySnapshot<Map<String, dynamic>>> readAppointments() {
    String userId = user.uid;
    final apppRef = FirebaseFirestore.instance.collection('Bids');
    return apppRef
        .where('Appointment_ID', isEqualTo: widget.appointId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.portrait_sharp),
          title: const Text('All bids'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: readAppointments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              print('SOMETHINGG + $snapshot.data');
              final bids = snapshot.data!.docs;
              return ListView.builder(
                itemCount: bids.length,
                itemBuilder: (context, index) {
                  final bid = bids[index];
                  return ListTile(
                    title: Text(bid['Amount']),
                    subtitle: Text(bid['Estimated_duration'].toString()),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Text('SOMETHING WENT WRONG');
            }
          },
        ));
  }
}
