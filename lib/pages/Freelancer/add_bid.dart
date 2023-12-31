import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_final_project/components/button.dart';
import 'package:cp_final_project/components/textfield.dart';
import 'package:cp_final_project/pages/Freelancer/view_all_bids.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class placeBid extends StatefulWidget {
  final String appointId;
  const placeBid({
    super.key,
    required this.appointId,
  });

  @override
  State<placeBid> createState() => _placeBidState();
}

class _placeBidState extends State<placeBid> {
  //Controllers for bid amount and estimated duration
  final amtController = TextEditingController();
  final durationController = TextEditingController();

  //Current user ID
  final user = FirebaseAuth.instance.currentUser!;

  //Save bid to Bids collection
  saveBid(String amount, String duration) {
    String userId = user.uid;
    String appointId = widget.appointId;
    FirebaseFirestore.instance.collection('Bids').add({
      'User_ID': userId,
      'Appointment_ID': appointId,
      'Amount': 'K$amount',
      'Estimated_duration': duration,
    });
  }

  //View bids posted by other users on the same job
  void goToBids() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => viewBids(
                appointId: widget.appointId,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Place a bid'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          //Form for adding a bid
          children: [
            const SizedBox(
              height: 30,
            ),
            textField(
                controller: amtController,
                hintText: '',
                hideText: false,
                labelText: 'Enter Amount(ZMW)',
                keyboardType: TextInputType.number),
            const SizedBox(
              height: 30,
            ),
            textField(
                controller: durationController,
                hintText: '',
                hideText: false,
                labelText: 'Estimated delivery time e.g 30 minutes',
                keyboardType: TextInputType.text),
            const SizedBox(
              height: 35,
            ),
            button(
                onTap: () async {
                  saveBid(amtController.text.trim(),
                      durationController.text.trim());
                  goToBids();
                },
                text: 'Place bid')
          ],
        ),
      )),
    );
  }
}
