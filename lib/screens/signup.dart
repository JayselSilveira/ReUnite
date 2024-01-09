import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missing_child/services/firebase_authentication_methods.dart';
import 'package:missing_child/utils/showSnackBar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);


  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _formKey = GlobalKey<FormState>();

  String? validateForm(String? value) { //validation to prevent taking empty input
    if (value=='') {
      return 'Required Field. Cannot be empty!';
    }
  }

  String? validatePhoneNo(String? value) { //Phone Number validation
    if (value=='') {
      return 'Required Field. Cannot be empty!';
    }

    if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value!)) { //with + country code
      return "Please enter a valid phone number";
    }
  }

  //TODO: add dispose method to dispose email and password

  // User? user = FirebaseAuth.instance.currentUser;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phnoController = TextEditingController();


  // @override
  // void dispose(){
  //   super.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   nameController.dispose();
  // }





  void signUp() async{
    FirebaseAuthMethods(FirebaseAuth.instance).signUpUsingEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context,
        fname: fnameController.text,
        lname: lnameController.text,
        phoneno: phnoController.text,
    );
    //TODO: move to home page if successful
    // Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
    // if (user != null) {
    //   Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
    // }

    // nameController.clear();
    // emailController.clear();
    // passwordController.clear();
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
              Text('Sign Up', style: TextStyle(fontSize: 28),),
            ]
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      const [
                        Expanded(
                        child: Text('Enter the following details to create an account.',
                            style: TextStyle(fontSize: 25),textAlign: TextAlign.center),
                      )
                      ],
                    ),

                    const SizedBox(height: 35),
                    TextFormField(
                      validator: validateForm,
                      controller: fnameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your First Name',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.label),
                          labelText: 'First Name',
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      validator: validateForm,
                      controller: lnameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Last Name',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.label_outline),
                        labelText: 'Last Name',
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                          labelText: 'Email',
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      validator: validatePhoneNo,
                      controller: phnoController,
                      keyboardType: TextInputType.number, //shift the keyboard to display only digits
                      decoration: const InputDecoration(
                        hintText: 'Enter your Phone No.',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.phone),
                        labelText: 'Phone No.',
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      // obscureText: true,
                      obscureText: isHidden,
                      controller: passwordController,
                      decoration:  InputDecoration(
                        hintText: 'Enter your Password',
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
                          if (_formKey.currentState!.validate()) {
                          signUp();

                        }
                          // TODO: Add snackbar to show registeration successful
                        },
                        child: const SizedBox(
                            width: 50,
                            child: Text('Sign Up'))
                    ),
                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}

