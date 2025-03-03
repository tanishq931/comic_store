import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/RowHeader.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

Widget PopularCharacters(
    {String title = '', bool showButton = true, List? characters,var onTap}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    RowHeader(
        title: title, btnText: 'view', onPress: () {}, showButton: showButton),
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
                            imageUrl: characters[i]['imgUrl'],
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      characters[i]['name'],
                      style: heading(color: Colors.white, size: 14),
                      textAlign: TextAlign.center,
                    )
                  ]),
                ),
                onTap: () {
                  onTap(i);
                });
          },
          itemCount: characters!.length),
    )
  ]);
}
