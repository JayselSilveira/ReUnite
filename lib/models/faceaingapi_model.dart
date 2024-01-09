import 'package:cloud_firestore/cloud_firestore.dart';

class FaceAgingApi{
  final String imageURL;

  FaceAgingApi({
    required this.imageURL
  });

  static FaceAgingApi fromJson(Map<String,dynamic> json) => FaceAgingApi(

    imageURL: json['imageURL'],

  );

}