import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:missing_child/models/missingchildren_model.dart';
import '../services/firebase_authentication_methods.dart';

class EditMissingChildPage extends StatefulWidget {
  const EditMissingChildPage({Key? key}) : super(key: key);


  @override
  State<EditMissingChildPage> createState() => _EditMissingChildPageState();
}

class _EditMissingChildPageState extends State<EditMissingChildPage> {

  final _formKey = GlobalKey<FormState>();

  String choice = 'no';
  bool isFound = false;
  String gender = 'Unknown';

  TextEditingController useridController = TextEditingController();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageinpicController = TextEditingController();
  TextEditingController agewhenmissingController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController missingdateController = TextEditingController();
  TextEditingController docidController = TextEditingController();
  TextEditingController genderController = TextEditingController();


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

  String? validateEmail(String? value) { //Email validation
    if (value=='') {
      return 'Required Field. Cannot be empty!';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
      return "Please enter a valid email address";
    }
  }


  editSelectedChild(fname,lname,ageinpic,agewhenmissing,region,phno,email,isfound,docid,gender) async {

    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection(
        'missingchildren')
        .where('doc_id', isEqualTo: docid)
        .get(); //get only that document which contains the document id
    QueryDocumentSnapshot doc = querySnap
        .docs[0]; // Works only if the query returns one document. Incase it will always be one as document ids are unique
    DocumentReference docRef = doc.reference;
    await docRef.update(
        {

          'first_name': fname,
          'last_name': lname,
          'age_in_pic': int.parse(ageinpic),
          'age_when_missing':int.parse(agewhenmissing),
          'region': region,
          'phone_number_contact': int.parse(phno),
          'email_contact': email,
          'is_found': isfound,
          'gender': gender
        }
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing Child Details Edited Successfully!'))
    );
  }



  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance; //to check if user is logged in
    final user = auth.currentUser;
    final uid = user?.uid; //to get user id of currently logged in user stored in firebase authentication
    useridController.text =uid!;
    print(uid);
    print(useridController.text);


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,//setting height of appBar
        centerTitle: true,
        title:  Column(
            children: const <Widget>[
              Text('Missing children added by you ', style: TextStyle(fontSize: 20),),
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
                        print('data ${snapshot.data}'); //remove // if '${snapshot.data}'=-'data null' show text no missing children added

                        // if (snapshot.hasData) {
                        if (snapshot.hasData && snapshot.data?.length != 0 ) { //if there is data in the snapshot, ie missing child added by user
                          print(snapshot.data?.length); //remove
                          final missingchildren = snapshot.data!;
                          // return ListView(

                          return ListView(
                            // GridView.count(
                            //
                            // crossAxisCount: 2,
                            children: missingchildren.map(buildMissingchildren).toList(),

                          );
                        }
                        else if(snapshot.hasData && snapshot.data?.length == 0) { //if there is no data in the snapshot, ie no missing child added by user
                          return const Text("You have not added any missing children.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),);
                        }
                        // else if(snapshot.hasData && snapshot.data==null) {
                        //   // data is obtained from snapshot but it is empty
                        //   return const Text("You have not added any missing children",textAlign: TextAlign.center,);
                        // }

                        else if(snapshot.hasError){
                          return const Text("Something went wrong",textAlign: TextAlign.center);
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



  // Stream<List<Missingchildren>> readMissingchildren() => FirebaseFirestore.instance
  //     .collection('missingchildren').where('user_id',isEqualTo: useridController.text)
  //     .snapshots()
  //     .map((snapshot) =>
  //     snapshot.docs.map((doc) => Missingchildren.fromJson(doc.data())).toList());


 //displays all missing children where is_found ==false ie they are still missing and added by user
  Stream<List<Missingchildren>> readMissingchildren() => FirebaseFirestore.instance
      .collection('missingchildren').where('user_id',isEqualTo: useridController.text).where('is_found',isEqualTo: false)
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
                  docidController.text = missingchildren.doc_id;
                  genderController.text = missingchildren.gender;


                  Timestamp t = missingchildren.date_of_missing; //to access date and time
                  DateTime date = t.toDate();
                  String formattedDate = DateFormat.yMMMd().format(date);
                  print('formatted date: $formattedDate');

                  missingdateController.text =formattedDate;

                  showDialog(
                      context: context,
                      builder: (context) =>StatefulBuilder( //statebuilder to refresh the dialog box so that radio button selection works
                          builder: (context, setState) {

                            return
                              Dialog(
                                insetPadding: EdgeInsets.all(10),
                                child: Scrollbar( //adding vertical scrollbar
                                  thumbVisibility:true ,
                                  thickness: 10,
                                  child: Form(
                                    key: _formKey,
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(15),
                                      children: <Widget>[

                                        const SizedBox(height: 20),
                                        const Center(
                                            child: Text(
                                              'Edit Missing Child Details',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight
                                                      .bold),)
                                        ),


                                        const SizedBox(height: 35),
                                        TextFormField(
                                          validator: validateForm,
                                          controller: fnameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter the child\'s First Name',
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
                                            hintText: 'Enter the child\'s Last Name',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.label_outline),
                                            labelText: 'Last Name',
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(38, 0, 0, 0),
                                          child: Container(
                                            width: 260,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.black26),
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),

                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 5,),
                                                  const Text(
                                                      'Select Gender: '),

                                                  RadioListTile(
                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                    dense: true,
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text("Male"),
                                                    value: "Male",
                                                    groupValue: genderController.text,
                                                    onChanged: (value){
                                                      setState(() {
                                                        genderController.text = value.toString();
                                                      });
                                                    },
                                                  ),

                                                  RadioListTile(
                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                    dense: true,
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text("Female"),
                                                    value: "Female",
                                                    groupValue: genderController.text,
                                                    onChanged: (value){
                                                      setState(() {
                                                        // gender = value.toString();
                                                        genderController.text = value.toString();
                                                      });
                                                    },
                                                  ),

                                                  RadioListTile(
                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                    dense: true,
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text("Other"),
                                                    value: "Other",
                                                    groupValue: genderController.text,
                                                    onChanged: (value){
                                                      setState(() {
                                                        genderController.text = value.toString();
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: validateForm,
                                          controller: ageinpicController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter child\'s age in the picture',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.person),
                                            labelText: 'Age in Picture',
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        Text('Date of Missing: ${missingdateController.text}'),

                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: validateForm,
                                          controller: agewhenmissingController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter child\'s age when missing',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.person_outline),
                                            labelText: 'Age when Missing',
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: validateForm,
                                          controller: regionController,
                                          decoration: const InputDecoration(
                                            hintText: 'Region where went missing',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.place),
                                            labelText: 'Region',
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        const Text('Details of the person to be contacted if information on missing child is found:',
                                          textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),

                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: validatePhoneNo,
                                          controller: phnoController,
                                          keyboardType: TextInputType.number, //shift the keyboard to display only digits
                                          decoration: const InputDecoration(
                                            hintText: 'Enter the Phone No.',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.phone),
                                            labelText: 'Phone No.',
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: validateEmail,
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter the Email.',
                                            border: OutlineInputBorder(),
                                            icon: Icon(Icons.email),
                                            labelText: 'Email',
                                          ),
                                        ),


                                        const SizedBox(height: 20),
                                        Row(
                                          children: <Widget>[
                                            const Text(
                                                'Child Found?'),
                                            Radio(
                                              value: "yes",
                                              groupValue: choice,
                                              onChanged: (value) {
                                                setState(() {
                                                  choice = value.toString();
                                                  isFound = true;
                                                  // approvedField = true;

                                                });
                                              },

                                            ),
                                            const Text('Yes'),

                                            Radio(
                                              value: "no",
                                              groupValue: choice,
                                              onChanged: (value) {
                                                setState(() {
                                                  choice = value.toString();
                                                  isFound = false;

                                                });
                                              },
                                            ),
                                            const Text('No'),

                                          ],
                                        ),
                                        const Text('Note: If you select yes, the details of the child will be removed from the list of missing children',
                                          textAlign: TextAlign.center,style: TextStyle(fontStyle: FontStyle.italic),),

                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!.validate()) {

                                                    editSelectedChild(fnameController.text,
                                                        lnameController.text,
                                                        ageinpicController.text,
                                                        agewhenmissingController.text,
                                                        regionController.text,
                                                        phnoController.text,
                                                        emailController.text,
                                                        isFound,
                                                        docidController.text,
                                                        genderController.text,
                                                    );
                                                  }
                                                },

                                                child: const Text('Update')
                                            ),
                                            const SizedBox(width: 20),
                                            ElevatedButton( //close dialog box
                                                onPressed: () {
                                                    Navigator.of(context).pop();
                                                },

                                                child: const Text('Close')
                                            ),
                                          ],
                                        )


                                      ],
                                    ),
                                  ),
                                ),
                              );

                          }
                      )
                  );



                },
                icon: const Icon(Icons.edit,color: Colors.white,),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

