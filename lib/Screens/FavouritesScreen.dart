import 'package:comic_store/Components/ComicGrid.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Comicprovider>(context);

    List getList(){
      List list = List.from(provider.comics);
      list.removeWhere((val){
        return !provider.favourites.contains(val['id']);
      });
      return list;
    }

    return provider.favourites.isNotEmpty
        ? ComicGrid(list: getList())
        : Center(
      child: Text('No comic in favourites',style: heading(),)
    );
  }
}
