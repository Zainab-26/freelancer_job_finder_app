// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cp_final_project/main.dart';
import 'package:flutter/material.dart';

class title extends StatefulWidget {
  const title({super.key});

  @override
  State<title> createState() => titleState();
}

class titleState extends State<title> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.portrait_sharp),
          title: Text('Create Profile'),
          centerTitle: true,
        ),
        body: PageView(controller: pageController, children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Text(
                      'Hello there. Get ready for your big opportunity!',
                      style: TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Icon(Icons.person),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Text(
                                'Answer these questions and build your profile'),
                            Padding(
                              padding: EdgeInsets.only(bottom: 100.0),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Icon(Icons.mail),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Expanded(
                                child: Text(
                                    'Apply for roles or post jobs that need to be done')),
                            Padding(
                              padding: EdgeInsets.only(bottom: 100.0),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Icon(Icons.money),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Text(
                                'Get paid or make paymnets safely and securely'),
                            Padding(
                              padding: EdgeInsets.only(bottom: 100.0),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 150)),
                            Expanded(
                              child: Text(
                                'This will only take 10 to 15 minutes, you can edit it later.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              child: Text('Lets get started'),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const Login(onTap: ,)),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
                                  fixedSize: Size(0, 50),
                                  elevation: 15,
                                  shape: StadiumBorder()),
                            ))
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          )
        ]));
  }
}
