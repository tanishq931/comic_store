import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Comic.dart';

Future getComics() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('comics').get();
  return Comic.getComicList(snapshot.docs);
}
