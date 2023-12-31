import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class myReviews extends StatefulWidget {
  const myReviews({Key? key}) : super(key: key);

  @override
  State<myReviews> createState() => _myReviewsState();
}

class _myReviewsState extends State<myReviews> {
  //Get current user
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, String> clientNames = {};

  @override
  void initState() {
    super.initState();
    print('initState');
    fetchClientNames();
  }

  //Get name of client who posted the review
  Future<void> fetchClientNames() async {
    print('Fetching client names...');
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('CLient_user').get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        for (var doc in snapshot.docs) {
          final clientId = doc['User_ID'];
          final clientName = doc['Name'];
          clientNames[clientId] = clientName;
        }
      });
    }

    print('$clientNames');
  }

  //Read all reviews from Reviews collection that are for the current logged in user
  Stream<QuerySnapshot<Map<String, dynamic>>> readReviews() {
    String userId = user.uid;
    final apppRef = FirebaseFirestore.instance.collection('Reviews');
    return apppRef.where('Freelancer_ID', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('My Appointments'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: readReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final reviews = snapshot.data!.docs;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final rating = review['Rating'];
                final clientId = review['Client_ID'];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(review['Review']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Flutter Package to allow user ratings
                          RatingBar.builder(
                            initialRating: rating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            ignoreGestures: true,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Text('Client Name: ${clientNames[clientId] ?? ''}')
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Text('SOMETHING WENT WRONG');
          }
        },
      ),
    );
  }
}
