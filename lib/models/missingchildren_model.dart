import 'package:cloud_firestore/cloud_firestore.dart';

class Missingchildren{

  final String first_name;
  final String last_name;
  final int age_in_pic;
  final Timestamp date_of_missing;
  final int age_when_missing;
  final String region;
  final int phone_number_contact;
  final String email_contact;
  final String user_id;
  final bool is_found;
  final String doc_id;
  final String gender;
  final String imageURL;

  Missingchildren({
    required this.first_name,
    required this.last_name,
    required this.age_in_pic,
    required this.date_of_missing,
    required this.age_when_missing,
    required this.region,
    required this.phone_number_contact,
    required this.email_contact,
    required this.user_id,
    required this.is_found,
    required this.doc_id,
    required this.gender,
    required this.imageURL
  });

  static Missingchildren fromJson(Map<String,dynamic> json) => Missingchildren(

    first_name: json['first_name'],
    last_name: json['last_name'],
    age_in_pic: json['age_in_pic'],
    //created_on: json['created_on'] as Timestamp,
    date_of_missing: json['date_of_missing'] == null ? Timestamp.now(): json['date_of_missing'] as Timestamp,
    age_when_missing: json['age_when_missing'],
    region: json['region'],
    phone_number_contact: json['phone_number_contact'],
    email_contact: json['email_contact'],
    user_id: json['user_id'],
    is_found: json['is_found'],
    doc_id: json['doc_id'],
    gender: json['gender'],
    imageURL: json['imageURL'],

  );

}