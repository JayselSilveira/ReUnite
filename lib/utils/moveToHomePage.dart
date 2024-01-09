import 'package:flutter/material.dart';

void moveToHomePage(BuildContext context){
  // Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
  Navigator.of(context).pushReplacementNamed('/homepg'); //will not display the login/signup pages if back is pressed
}