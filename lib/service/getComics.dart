import 'package:cloud_firestore/cloud_firestore.dart';

Future getComics() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('comics').get();
  return snapshot.docs;
}