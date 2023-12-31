import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/pages/Freelancer/job_details.dart';
import 'package:flutter/material.dart';

class jobCard extends StatelessWidget {
  final String jobTitle;
  final String date;
  final String time;
  final DocumentSnapshot jobSnapshot;

  const jobCard(
      {super.key,
      required this.jobTitle,
      required this.date,
      required this.time,
      required this.jobSnapshot});

  //Design for displaying jobs on explore page
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 180,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        jobTitle,
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(date),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Time: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(time),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JobDetailsPage(
                        jobSnapshot: jobSnapshot,
                      ),
                    ));
                  },
                  child: Center(child: const Text('Details')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
