import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/PopularCharacters.dart';
import 'package:comic_store/Screens/PDFScreen.dart';
import 'package:comic_store/provider/AuthProvider.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailsScreen extends StatefulWidget {
  final String tag;
  final dynamic bookDetails;
  const DetailsScreen({super.key, this.bookDetails = '', required this.tag});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Comicprovider>(context);
    final authProvider = Provider.of<UserProvider>(context);
    bool isLiked = authProvider.favouritesList.contains(widget.bookDetails.id);

    Future<bool> onLikeButtonTapped(bool isLiked) async {
      var firestore = FirebaseFirestore.instance.collection('users').doc(authProvider!.uid);
      List list  = List.from(authProvider.favouritesList);
      if(isLiked){
         list.remove(widget.bookDetails.id);
      }else{
        list.add(widget.bookDetails.id);
      }
      authProvider.setFavouritesList(list);
      firestore.update({'favouritesList':list});
      return !isLiked;
    }
    final isAdmin = Provider.of<UserProvider>(context).isAdmin;
    void onPressDelete() async {
      await FirebaseFirestore.instance
          .collection('comics')
          .doc(widget.bookDetails['id'])
          .delete();
      Reference bannerRef = storage.refFromURL(widget.bookDetails['banner']);
      Reference comicRef = storage.refFromURL(widget.bookDetails['pdf']);
      await bannerRef.delete();
      await comicRef.delete();

      List list = List.from(provider.comics);
      list.removeWhere((val){
        return val['id']==widget.bookDetails['id'];
      });
      provider.setComics(list);
      Navigator.pop(context);
    }

    Future showDeleteDialog(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  'Are you sure you want to delete this comic ?',
                  style: heading(color: Colors.black),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No, cancel',
                        style: heading(size: 12, color: Colors.blue.shade800),
                      )),
                  TextButton(
                      onPressed: () {
                        onPressDelete();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes, delete',
                        style: heading(size: 12, color: Colors.red),
                      )),
                ],
                actionsAlignment: MainAxisAlignment.end,
                actionsPadding: const EdgeInsets.only(right: 10));
          });
    }

    return Scaffold(
      appBar: CommonAppbar(
        title: widget.bookDetails['title'],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Center(
                          child: Hero(
                            tag: widget.tag,
                            child: CachedNetworkImage(
                              imageUrl: widget.bookDetails['banner'],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 10,
                          child: LikeButton(
                              isLiked:isLiked ,
                              size: 30,
                              circleColor: const CircleColor(
                                  start: Colors.red, end: Colors.red),
                              bubblesColor: const BubblesColor(
                                  dotPrimaryColor: Colors.red,
                                  dotSecondaryColor: Colors.red),
                              onTap: onLikeButtonTapped),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookDetails['title'],
                              style: heading(size: 18, weight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 1.5),
                                      child: Text(
                                          widget.bookDetails['ratings']
                                              .toString(),
                                          style: heading(size: 12))),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(widget.bookDetails['language'],
                                      style: heading(
                                          size: 12, color: Colors.grey)),
                                  const SizedBox(width: 5),
                                  Text(
                                    ' • ${widget.bookDetails['pages']} pages',
                                    style:
                                        heading(size: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            descRow('Author : ', widget.bookDetails['author']),
                            descRow('Publisher : ',
                                widget.bookDetails['publisher']),
                            Text(
                              'Description :',
                              style: heading(size: 14),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.bookDetails['descHi'],
                              style: heading(size: 12, color: Colors.grey),
                            ),
                            Consumer<Comicprovider>(
                                builder: (context, val, child) {
                              var list = List.from(val.characters);
                              list.removeWhere((element) {
                                return !widget.bookDetails['characters']
                                    .contains(element['id']);
                              });
                              return PopularCharacters(
                                title: 'Characters',
                                characters: list,
                                showButton: false,
                              );
                            }),
                          ],
                        ),
                      ),
                      // WebView
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: isAdmin ? 110 : 50,
        child: Column(
          children: [
            if (isAdmin)
              CustomButton(
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete_outline_outlined,
                            color: Colors.white),
                        Text(
                          'Delete',
                          style: heading(),
                        ),
                      ],
                    )),
                  ),
                  onTap: () {
                    showDeleteDialog(context);
                  }),
            if (isAdmin) const SizedBox(height: 10),
            CustomButton(
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    'Open',
                    style: heading(),
                  )),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFScreen(bookDetails: widget.bookDetails)));
                }),
          ],
        ),
      ),
    );

  }



  Widget descRow(String title, String desc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title, style: heading(size: 12)),
          Text(
            desc,
            style: heading(size: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
