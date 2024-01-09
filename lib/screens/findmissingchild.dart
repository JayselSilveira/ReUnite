import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:missing_child/models/missingchildren_model.dart';
import '../services/firebase_authentication_methods.dart';

class FindMissingChildPage extends StatefulWidget {
  const FindMissingChildPage({Key? key}) : super(key: key);


  @override
  State<FindMissingChildPage> createState() => _FindMissingChildPageState();
}

class _FindMissingChildPageState extends State<FindMissingChildPage> {


  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageinpicController = TextEditingController();
  TextEditingController agewhenmissingController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController missingdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,//setting height of appBar
        centerTitle: true,
        title:  Column(
            children: const <Widget>[
              Text('Find a missing child', style: TextStyle(fontSize: 28),),
            ]
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 650,
                    width: 350,
                    child: StreamBuilder<List<Missingchildren>>(
                      stream: readMissingchildren(),
                      builder: (context,snapshot) {
                        print('data ${snapshot.data}'); //remove //TODO: if '${snapshot.data}'='data null' show text no missing children added

                        if (snapshot.hasData) {
                          final missingchildren = snapshot.data!;
                          return ListView(
                          // return GridView.count(
                          //
                          //   crossAxisCount: 2,
                            children: missingchildren.map(buildMissingchildren).toList(),

                          );
                        }
                        else if(snapshot.hasError){
                          return const Text("Something went wrong");
                        }
                        else{
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),


                ],
              ),
            ),

          ),
        ),
      ),
    );
  }

  //displays all missing children even if they are found
  // Stream<List<Missingchildren>> readMissingchildren() => FirebaseFirestore.instance
  //     .collection('missingchildren')
  //     .snapshots()
  //     .map((snapshot) =>
  //     snapshot.docs.map((doc) => Missingchildren.fromJson(doc.data())).toList());

  //displays all missing children where is_found ==false ie they are still missing
  Stream<List<Missingchildren>> readMissingchildren() => FirebaseFirestore.instance
      .collection('missingchildren').where('is_found',isEqualTo: false)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Missingchildren.fromJson(doc.data())).toList());


  Widget buildMissingchildren(Missingchildren missingchildren) {
    Timestamp t = missingchildren.date_of_missing; //to access date and time
    DateTime date = t.toDate();

    return  Column(
      children: [
        //Text('$listOfCustomers'),


        Container(
          height: 120,
          child: Card(
            color: Colors.black45,
            elevation: 4,
            child:

            ListTile(
              leading: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 50,
                  maxWidth: 70,
                  maxHeight: 100,
                ),
                child:
                // Container(
                //   decoration: const BoxDecoration(
                //       image: DecorationImage(
                //           image: AssetImage('assets/images/placeholder.jpg'),
                //           fit: BoxFit.fill
                //       )
                //   ),
                // ),
                Container( //uncomment this
                  decoration:  BoxDecoration(
                      image: DecorationImage(
                          // image: AssetImage('assets/images/placeholder.jpg'),
                          image: NetworkImage(missingchildren.imageURL),
                          fit: BoxFit.fill
                      )
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    'Name: ${missingchildren.first_name} ${missingchildren.last_name} ',
                    textAlign: TextAlign.start, style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                ),
                  Text(
                    'Region of missing: ${missingchildren.region}',
                    textAlign: TextAlign.start, style: const TextStyle(color: Colors.white),
                ),

                  // Text(
                  //   'First Name: ${missingchildren.first_name}',
                  //     textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),
                  // ),
                  // Text(
                  //   'Last Name: ${missingchildren.last_name}',
                  //     textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),
                  // ),
                ],
              ),
              // subtitle: Column(
              //     children: <Widget>[
              //       const SizedBox(height: 10,),
              //       Text(
              //         'Region of missing: ${missingchildren.region}',
              //         // textAlign: TextAlign.center,
              //         style: const TextStyle(color: Colors.white,),
              //
              //       ),
              //
              //     ]
              // ),

              trailing: IconButton(
                onPressed: (){

                  fnameController.text = missingchildren.first_name;
                  lnameController.text = missingchildren.last_name;
                  ageinpicController.text = missingchildren.age_in_pic.toString();
                  agewhenmissingController.text = missingchildren.age_when_missing.toString();
                  regionController.text = missingchildren.region;
                  phnoController.text = missingchildren.phone_number_contact.toString();
                  emailController.text = missingchildren.email_contact;
                  genderController.text = missingchildren.gender;
                  imageURLController.text = missingchildren.imageURL;



                    Timestamp t = missingchildren.date_of_missing; //to access date and time
                    DateTime date = t.toDate();
                    String formattedDate = DateFormat.yMMMd().format(date);
                    print('formatted date: $formattedDate');
                    //approveddateController.text ='${date.month} ${date.day}, ${date.year}';
                    missingdateController.text =formattedDate;

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {

                            return
                              Dialog(
                                insetPadding: EdgeInsets.all(10),
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(15),
                                  children: <Widget>[

                                    const Center(
                                        child: Text(
                                          'Missing Child Details',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight
                                                  .bold),)
                                    ),

                                    // Add pic of child
                                    const SizedBox(height: 20),
                                    // Container(
                                    //   child:
                                    //   Image.asset(
                                    //     'assets/images/placeholder.jpg',
                                    //     height: 170,
                                    //     width: 100,
                                    //   )
                                    //
                                    //   // height: 150,
                                    //   // width: 100,
                                    //   // decoration: const BoxDecoration(
                                    //   //     image: DecorationImage(
                                    //   //         image: AssetImage('assets/images/placeholder.jpg'),
                                    //   //         fit: BoxFit.fill
                                    //   //     )
                                    //   // ),
                                    // ),

                                    Container( //display the image from firebase storage using the url stored in firestore database
                                      //uncomment this
                                      width: 400,
                                      height: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(imageURLController.text),
                                          // fit: BoxFit.cover,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 35),
                                     Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0), //applying padding L-Left, T-Top, R-Right, B-Bottom (LTRB)
                                      child:
                                      Text.rich( //using text.rich to make first part of text bold
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Name: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${fnameController.text} ${lnameController.text}',
                                            ),
                                          ],
                                        ),
                                      ),


                                      // Text('Name: ${fnameController.text} ${lnameController.text} '),
                                    ),

                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Gender: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${genderController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Date of Missing: ${missingdateController.text}'),
                                    ),


                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Date of Missing: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${missingdateController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Date of Missing: ${missingdateController.text}'),
                                    ),

                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Age when missing: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${agewhenmissingController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Age when missing: ${agewhenmissingController.text}'),
                                    ),

                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Age in Picture: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${ageinpicController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Age in Picture: ${ageinpicController.text}'),
                                    ),

                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Region where went missing: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${regionController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Region where went missing: ${regionController.text}'),
                                    ),


                                    const SizedBox(height: 20),
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text('Contact details in case child or information about child is found:',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 18),
                                      textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Phone no: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${phnoController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('Phone no: ${phnoController.text}'),
                                    ),

                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child:
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'email: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${emailController.text}',
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Text('email: ${emailController.text}'),
                                    ),


                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        ElevatedButton( //close dialog box
                                            onPressed: () {

                                              Navigator.of(context).pop();
                                              // Navigator.of(context).pushNamedAndRemoveUntil('/homepg',(Route<dynamic> route)=>false);// pop all prev routes

                                            },

                                            child: const Text('Close')
                                        ),
                                      ],
                                    )


                                  ],
                                ),
                              );

                          }

                  );

                  // Show full details in a new page or dialog box


                },
                icon: const Icon(Icons.open_in_new,color: Colors.white,),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

