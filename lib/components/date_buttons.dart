import 'package:flutter/material.dart';

//Design the buttons to add a date

class dateButton extends StatelessWidget {
  final String hintText;
  final method;

  const dateButton({super.key, required this.hintText, required this.method});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.all(15),
        ),
        onPressed: method,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://pics.freeicons.io/uploads/icons/png/16784855481557740332-512.png',
              height: 24.0,
            ),
            const SizedBox(width: 10.0),
            Text(hintText),
          ],
        ),
      ),
    );
  }
}
