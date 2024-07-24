import 'package:comic_store/Components/ComicGrid.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
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
        body: Container(
          margin: const EdgeInsets.all(10),
          child: ComicGrid(list: widget.list),
        ));
  }
}
