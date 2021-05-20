import 'package:cats_breed_identifier/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
    seconds: 5,
      navigateAfterSeconds: HomeScreen(),
      title: Text("Cat Breed Identifier", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.purple,
        fontFamily: "Signatra"
      ),),
      image: Image.asset("assets/icon.jpg"),
      backgroundColor: Colors.white,
      photoSize: 150,
      loaderColor: Colors.purple,
      loadingText: Text("By M.U.K", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.purple,
          fontFamily: "Brand Bold"
      ),),
    );
  }
}
