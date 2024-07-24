import 'package:comic_store/Components/ComicGrid.dart';
import 'package:comic_store/Components/CommonInput.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Comicprovider>(context);
    List getList(){
      List list  = List.from(provider.comics);
      list.removeWhere((val){
        return !val['title'].toLowerCase().contains(searchText.text.toLowerCase());
      });
      return list;
    }
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CommonInput(
              controller: searchText,
              label: 'Enter Comic Name',
              icon: const Icon(Icons.search),
            onChangeText: (val){
                setState(() {});
            }
          ),
          const SizedBox(height: 10),
          Expanded(
                  flex: 1,
                  child: searchText.text.isEmpty
                      ? Center(
                          child: Text(
                            'Enter Something to start search',
                            style: heading(),
                          ))
                      : ComicGrid(list: getList())
                ),
        ],
      ),
    ));
  }
}
