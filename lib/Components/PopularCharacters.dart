import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/RowHeader.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularCharacters extends StatefulWidget {
  final String title;
  final List characters;
  final bool showButton;
  const PopularCharacters({super.key,required this.title,required this.characters,this.showButton=true});

  @override
  State<PopularCharacters> createState() => _PopularCharactersState();
}

class _PopularCharactersState extends State<PopularCharacters> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RowHeader(title: widget.title, btnText: 'view', onPress: () {},showButton: widget.showButton),
      const SizedBox(height: 10),
      SizedBox(
        height: 150,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return CustomButton(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 100,
                    child: Column(children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: widget.characters[i]['imgUrl'],
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.characters[i]['name'],
                        style: heading(color: Colors.white, size: 14),
                        textAlign: TextAlign.center,
                      )
                    ]),
                  ),
                  onTap: () {});
            },
            itemCount: widget.characters.length),
      )
    ]);
  }
}
