import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missing_child/services/firebase_authentication_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _auth = FirebaseAuth.instance;
class _LoginPageState extends State<LoginPage> {

  // User? user = FirebaseAuth.instance.currentUser;
  // TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //TODO: add dispose method to dispose email and password
  // @override
  // void dispose(){
  //   super.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   nameController.dispose();
  // }

  void logIn(){
   FirebaseAuthMethods(FirebaseAuth.instance).logInUsingEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context,
    );
    //TODO: move to home page if successful
    // Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
    // if (user != null) {
    //   Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
    // }
  }

  bool isHidden = true; //setting password as hidden initially

  void viewHidePassword() { //function to show/hide password
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,//setting height of appBar
        centerTitle: true,
        title:  Column(
            children: const <Widget>[
              Text('Log In', style: TextStyle(fontSize: 28),),
            ]
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    const[Expanded(child: Text('Enter the details to proceed with the login',
                      style: TextStyle(fontSize: 25),textAlign: TextAlign.center,))],
                  ),

                  const SizedBox(height: 35),
                  TextFormField(

                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.email),
                      labelText: 'Email'
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    // obscureText: true,
                    obscureText: isHidden,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                      suffix: InkWell(
                        onTap: viewHidePassword,
                        child: Icon(
                          isHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: (){
                        logIn();
                      },
                      child: const SizedBox(
                          width: 40,
                          child: Text('Login'))
                  ),
                  const SizedBox(height: 40,),
                  const Text('Don\'t have an account?',textAlign: TextAlign.center, ),
                  const SizedBox(height: 5),
                  TextButton(
                      onPressed: (){

                        Navigator.pushNamed(context, "/signup");
                        emailController.clear();
                        passwordController.clear();

                      },
                      child: const SizedBox(
                          width: 60,
                          child: Text('Sign Up',style: TextStyle(fontSize: 17 ),))
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}

