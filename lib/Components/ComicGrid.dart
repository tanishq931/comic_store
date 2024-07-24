import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Screens/DetailsScreen.dart';
import 'package:flutter/material.dart';

class ComicGrid extends StatefulWidget {
  final List list;
  const ComicGrid({super.key,required this.list});

  @override
  State<ComicGrid> createState() => _ComicGridState();
}

class _ComicGridState extends State<ComicGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          crossAxisSpacing: 10,
          mainAxisExtent: 160,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return Hero(
          // tag: '${widget.list[index]['id']}',
          tag: 'hello',
          child: CustomButton(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.list[index]['banner'],
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                            bookDetails: widget.list[index],
                            tag:
                            '${widget.list[index]['id']}')
                    )
                );
              }),
        );
      },
      itemCount: widget.list.length,
    );
  }
}
