import 'package:cloud_firestore/cloud_firestore.dart';

Future getTopRatedComics() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('topRated').get();
  return snapshot.docs;
}