import 'package:cloud_firestore/cloud_firestore.dart';

getCharacters() async {
  QuerySnapshot snapshot =await FirebaseFirestore.instance.collection('characters').get();
  return snapshot.docs;
}
