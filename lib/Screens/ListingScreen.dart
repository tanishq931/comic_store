import 'package:comic_store/Components/Categories.dart';
import 'package:comic_store/Components/PopularCharacters.dart';
import 'package:comic_store/Components/TopCarousel.dart';
import 'package:comic_store/Screens/AllComics.dart';
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
    return Scaffold(

      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TopCarousel(
              items: provider.topRated,
              dots: true,
              top: true,
            ),
            PopularCharacters(
                title: 'Popular Characters',
                characters: provider.characters,
                onTap: (i) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    List list = List.from(provider.comics);
                    list.removeWhere((element) {
                      return !element['characters']
                          .contains(provider.characters[i]['id']);
                    });
                    return Allcomics(
                        list: list, title: provider.characters[i]['name']);
                  }));
                }),
            const Categories()
          ],
        ),
      )),
    );
  }
}
