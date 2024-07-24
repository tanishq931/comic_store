import 'package:comic_store/Components/RowHeader.dart';
import 'package:comic_store/Components/TopCarousel.dart';
import 'package:comic_store/Screens/AllComics.dart';
import 'package:flutter/material.dart';

class CategoryRow extends StatefulWidget {
  final String title;
  final String id;
  final List list;
  const CategoryRow(
      {super.key, required this.title, required this.id, required this.list});

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowHeader(
            title: widget.title,
            btnText: 'See all',
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Allcomics(list: widget.list, title: widget.title)));
            }),
        TopCarousel(
          items: widget.list,
          fraction: 0.3,
          ratio: 16 / 5.5,
          autoPlay: false,
          imgKey: 'banner',
          title: widget.title,

        ),
      ],
    );
  }
}
