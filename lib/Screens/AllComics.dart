import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Screens/DetailsScreen.dart';
import 'package:flutter/material.dart';

class Allcomics extends StatefulWidget {
  final String title;
  final List list;
  const Allcomics({super.key, required this.list, required this.title});

  @override
  State<Allcomics> createState() => _AllcomicsState();
}

class _AllcomicsState extends State<Allcomics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppbar(title: widget.title),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              crossAxisSpacing: 10,
              mainAxisExtent: 160,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return Hero(
              tag: '${widget.list[index]['id']}${widget.title}',
              child: CustomButton(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.list[index]['banner'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    print('${widget.list[index]['id']}${widget.title}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              bookDetails: widget.list[index],
                                tag:
                                    '${widget.list[index]['id']}${widget.title}')
                        )
                    );
                  }),
            );
          },
          itemCount: widget.list.length,
        ));
  }
}
