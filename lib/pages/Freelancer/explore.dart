import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/utilities/job_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class explore extends StatefulWidget {
  const explore({super.key});

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  final searchController = TextEditingController();

  final CollectionReference appointmentsRef =
      FirebaseFirestore.instance.collection('Appointments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: const Text('Jobs'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              //Text
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text('Experience new journeys',
                    style: GoogleFonts.bebasNeue(fontSize: 45)),
              ),
              const SizedBox(height: 30),

              //Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search for a job',
                                prefixIcon: Icon(Icons.search)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(
                          Icons.filter_list_sharp,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),

              //Text
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text(
                  'Jobs For You',
                  style: GoogleFonts.bebasNeue(fontSize: 35),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: 20),

              //Get appointments posted by clients and display them
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Appointments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return Container(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data = documents[index];
                        return jobCard(
                          jobTitle: data['Job_title'],
                          date: data['Appointment_date'],
                          time: data['Appointment_time'],
                          jobSnapshot: data,
                        );
                      },
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
