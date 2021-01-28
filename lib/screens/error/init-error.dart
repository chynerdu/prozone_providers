import 'package:flutter/material.dart';
import 'package:prozone/screens/intro/splash_screen.dart';

class InitError extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text('Initialization failed, unable to fetch some resources',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
        SizedBox(height: 20),
        MaterialButton(
            child: Text('Try again', style: TextStyle(color: Colors.white)),
            color: Color(0xff0047ff),
            elevation: 0,
            minWidth: 150,
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
              );
            })
      ],
    )));
  }
}
