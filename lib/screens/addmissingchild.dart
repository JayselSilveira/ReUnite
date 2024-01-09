
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_authentication_methods.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;





class AddMissingChildPage extends StatefulWidget {
  const AddMissingChildPage({Key? key}) : super(key: key);


  @override
  State<AddMissingChildPage> createState() => _AddMissingChildPageState();
}

class _AddMissingChildPageState extends State<AddMissingChildPage> {


  XFile? image;
  String url='';
  final ImagePicker picker = ImagePicker();

  // function to upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    String imageUrl = await uploadImageToFirebase(File(img!.path));
    setState(() {
      image = img;
      url = imageUrl;
    });
  }




  //dialog box
  void imageAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose a media: '),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton( // to upload image from gallery

                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text(' From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton( //to upload image from camera

                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text(' From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //function to upload image to firebase storage
  Future<String> uploadImageToFirebase(File file) async {
    FirebaseAuth auth = FirebaseAuth.instance; //to check if user is logged in
    final user = auth.currentUser;
    final uid = user?.uid; //to get user id of currently logged in user stored in firebase authentication
    print(uid);

    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child('uploadedImages/user_${uid}_${DateTime.now().toString()}.jpg');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }


  String date = '';
  String gender = 'Unknown';

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

  String? validateEmail(String? value) { //Email validation
    if (value=='') {
      return 'Required Field. Cannot be empty!';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
      return "Please enter a valid email address";
    }
  }




  //TODO: add dispose method to dispose email and password


  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageinpicController = TextEditingController();
  TextEditingController agewhenmissingController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance; //to check if user is logged in
    final user = auth.currentUser;
    final uid = user?.uid; //to get user id of currently logged in user stored in firebase authentication
    print(uid);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,//setting height of appBar
        centerTitle: true,
        title:  Column(
            children: const <Widget>[
              Text('Add a missing child', style: TextStyle(fontSize: 28),),
            ]
        ),
      ),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 5,
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
                        const[
                          Expanded(child: Text('Enter the details to add a missing child\'s information',
                          style: TextStyle(fontSize: 25),textAlign: TextAlign.center,))],
                      ),


                      const SizedBox(height: 20,),
                      //if image not null ie it is selected by user->show the image
                      //if image null ie it is not selected by user ->show text
                      image != null
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                          : const Text(
                        "No Image Selected",
                        style: TextStyle(fontSize: 20),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          imageAlert();
                        },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black26), //setting elevated button color
                        ),
                        child: const Text('Upload Photo'),
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
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),//<-- add this
                                    dense: true,//<-- add this
                                    contentPadding: EdgeInsets.zero,//<-- add this
                                    title: Text("Male"),
                                    value: "Male",
                                    groupValue: gender,
                                    onChanged: (value){
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),

                                  RadioListTile(
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),//<-- add this
                                    dense: true,//<-- add this
                                    contentPadding: EdgeInsets.zero,//<-- add this
                                    title: Text("Female"),
                                    value: "Female",
                                    groupValue: gender,
                                    onChanged: (value){
                                      setState(() {
                                        gender = value.toString();
                                      });
                                    },
                                  ),

                                  RadioListTile(
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),//<-- add this
                                    dense: true,//<-- add this
                                    contentPadding: EdgeInsets.zero,//<-- add this
                                    title: Text("Other"),
                                    value: "Other",
                                    groupValue: gender,
                                    onChanged: (value){
                                      setState(() {
                                        gender = value.toString();
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
                      DateTimePicker(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.calendar_month),
                            labelText: 'Date of missing'
                        ),
                        initialValue: '',
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Select the date of missing',
                        onChanged: (val) {
                          setState(() {
                            date = val;
                          });
                        },

                        validator: (val) { //making the date field as required
                          if(val==''){
                            // validateForm(val);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Date is a required field! Please select a date')));
                          }
                          print(val);
                          return null;
                        },

                        onSaved: (val) => print(val),
                      ),

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
                      ElevatedButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()) {



                              DateTime datetime = DateTime.parse(date);
                              final data = {
                                'first_name': fnameController.text,
                                'last_name': lnameController.text,
                                'age_in_pic': int.parse(ageinpicController.text),
                                'date_of_missing': datetime,
                                'age_when_missing': int.parse(agewhenmissingController.text),
                                'region': regionController.text,
                                'phone_number_contact': int.parse(phnoController.text),
                                'email_contact': emailController.text,
                                'user_id': uid,
                                'is_found': false,
                                'doc_id': 'documentid',
                                'gender': gender,
                                'imageURL' :url
                              };

                              //adding the missing child details to firebase missingchildren collection
                              FirebaseFirestore.instance.collection('missingchildren').add(data).then((documentSnapshot) {
                                //print("Added Data with ID: ${documentSnapshot.id}")
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        'Details Added Successfully!'))
                                );
                                print(documentSnapshot.id); //gives document id of newly created id

                                var collection = FirebaseFirestore.instance.collection('missingchildren');
                                collection
                                    .doc(documentSnapshot.id)
                                    .update({'doc_id' : documentSnapshot.id}) // <-- Updated data
                                    .then((_) => print('Success'))
                                    .catchError((error) => print('Failed: $error'));

                              }

                              //adding selected image to firebase storage




                              );




                              //TODO: add details to firebase
                              fnameController.clear();
                              lnameController.clear();
                              ageinpicController.clear();
                              agewhenmissingController.clear();
                              regionController.clear();
                              phnoController.clear();
                              emailController.clear();

                            }

                          },
                          child: const SizedBox(
                              width: 50,
                              child: Text('Add',textAlign: TextAlign.center,))
                      ),



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



