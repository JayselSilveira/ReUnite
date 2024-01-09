import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_authentication_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


 //TODO: Sign out and delete account functions and buttons move to appropriate locations
  void signOut() async{
    FirebaseAuthMethods(FirebaseAuth.instance).signOut(
        context,
    );

    Navigator.of(context).pushNamedAndRemoveUntil('/startpg',(Route<dynamic> route)=>false); // pop all prev routes and move to start screen
  }
  //
  // void deleteAccount() async{
  //   FirebaseAuthMethods(FirebaseAuth.instance).deleteAccount(
  //     context,
  //   );
  //
  //   Navigator.of(context).pushNamedAndRemoveUntil('/startpg',(Route<dynamic> route)=>false); // pop all prev routes and move to start screen
  // }

  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance; //to check if user is logged in
    final user = auth.currentUser;


    return Container(
      child: WillPopScope(
        onWillPop: () async { // disabling back button
          user==null
              ? //when user is not logged in
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                  'Press the Exit icon to exit application')
              )
          )
              : //when user is logged in
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                  'Please Sign Out to exit application ')
              )
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            toolbarHeight: 90,//setting height of appBar
            centerTitle: true,
            automaticallyImplyLeading: false, //to remove the default back arrow
            title:  Column(
                children: const <Widget>[
                  Text('Home Page', style: TextStyle(fontSize: 28),),
                ]
            ),
            actions: [
              user==null
              //when user is not logged in
                  ?
              IconButton(
                iconSize: 30,
                icon: const Icon(
                    Icons.exit_to_app
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/startpg',(Route<dynamic> route)=>false);
                  },
              )
              //when ussr is logged in
                  :
              // IconButton(
              //         iconSize: 30,
              //         icon: const Icon(
              //         Icons.account_circle
              //         ),
              //         onPressed: () {
              //
              //         },
              // )
              PopupMenuButton(
                  icon: const Icon(Icons.account_circle,size: 30,),
                  itemBuilder: (context){
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Sign Out"),
                      ),

                      // PopupMenuItem<int>(
                      //   value: 1,
                      //   child: Text("Settings"),
                      // ),
                    ];
                  },
                  onSelected:(value){
                    if(value == 0){
                      signOut();
                    }
                    // else if(value == 1){
                    //   print("Settings menu is selected.");
                    // }
                  }
              ),
            ],
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

                      GestureDetector(
                        onTap: (){
                          //move to find missing child pg on tap
                           Navigator.pushNamed(context, "/findmissingchild");

                        },
                        child: Container(
                          width: 300,
                          height: 140,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // color: Colors.teal.shade400,
                            color: Colors.teal,
                            // color: Colors.black26,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                ListTile(
                                  leading: Icon(Icons.search, size: 70, color:Colors.black ,),
                                  title: Text('Find Missing Children',
                                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          //move to add missing child pg on tap if signed in else move to login/signup page
                          if (user == null) {
                            Navigator.pushNamed(context, "/login");

                          } else {
                            Navigator.pushNamed(context, "/addmissingchild");
                          }
                        },
                        child: Container(
                          width: 300,
                          height: 140,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // color: Colors.teal.shade400,
                            color: Colors.teal,
                            // color: Colors.black26,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                ListTile(
                                  leading: Icon(Icons.add_circle, size: 70, color:Colors.black ,),
                                  title: Text('Add Missing Children Details',
                                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          //move to edit missing child pg on tap if signed in else move to login/signup page
                          // Navigator.pushNamed(context, "/startpg");
                          if (user == null) {
                            Navigator.pushNamed(context, "/login");

                          } else {
                            Navigator.pushNamed(context, "/editmissingchild");
                          }

                        },
                        child: Container(
                          width: 300,
                          height: 140,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // color: Colors.teal.shade400,
                            color: Colors.teal,
                            // color: Colors.black26,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                ListTile(
                                  leading: Icon(Icons.edit, size: 70, color:Colors.black ,),
                                  title: Text('Edit Missing Children Details',
                                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/faceaging");
                        },
                        child: Container(
                          width: 300,
                          height: 140,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // color: Colors.teal.shade400,
                            color: Colors.teal,
                            // color: Colors.black26,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                ListTile(
                                  leading: Icon(Icons.face, size: 70, color:Colors.black ,),
                                  title: Text('Face Aging',
                                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20,),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.pushNamed(context, "/apicall");
                      //     // Navigator.pushNamed(context, "/api"); //remove this - api code
                      //     // move to find missing child pg on tap
                      //     // Navigator.pushNamed(context, "/startpg");
                      //   },
                      //   child: Container(
                      //     width: 300,
                      //     height: 140,
                      //     child: Card(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       // color: Colors.teal.shade400,
                      //       color: Colors.teal,
                      //       // color: Colors.black26,
                      //       elevation: 10,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: const <Widget>[
                      //           ListTile(
                      //             leading: Icon(Icons.bar_chart, size: 70, color:Colors.black ,),
                      //             title: Text('Statistics',
                      //               style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ),
                      //
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      //Sign out and Delete account button code
                      // const SizedBox(height: 20,),
                      // ElevatedButton(
                      //     onPressed: (){
                      //       signOut();
                      //     },
                      //     child: const SizedBox(
                      //         width: 60,
                      //         child: Text('Sign Out'))
                      // ),
                      //
                      // const SizedBox(height: 20,),
                      // ElevatedButton(
                      //     onPressed: (){
                      //       deleteAccount();
                      //     },
                      //     child: const SizedBox(
                      //         width: 100,
                      //         child: Text('Delete Account'))
                      // ),

                    ],
                  ),
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}

