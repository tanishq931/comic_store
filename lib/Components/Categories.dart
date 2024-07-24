import 'package:comic_store/Components/CategoryRow.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Comicprovider>(context);

   return ListView.builder(
      itemBuilder: (context, i) {
        List list  = List.from(provider.comics);
        list.removeWhere((element){
          return !element['characters'].contains(provider.characters[i]['id']);
        });
        return CategoryRow(
            list:list,
            title: provider.characters[i]['name'], id: provider.characters[i]['id']);
      },
      itemCount: provider.characters.length ,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}