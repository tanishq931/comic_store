import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/Categories.dart';
import 'package:comic_store/Components/PopularCharacters.dart';
import 'package:comic_store/Components/TopCarousel.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  List list = [
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blue
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Comicprovider>(context);
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TopCarousel(
            items: provider.topRated,
            dots: true,
            title: 'TopRated',
          ),
          Consumer<Comicprovider>(builder: (context,val,child){
            return PopularCharacters(title: 'Popular Characters',characters:val.characters);
          }),

          const Categories()
        ],
      ),
    ));
  }
}
