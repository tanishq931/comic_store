import 'package:comic_store/service/LocalStorage.dart';
import 'package:flutter/cupertino.dart';

class Comicprovider extends ChangeNotifier{
  List _comics = [];
  List _characters =[];
  List _topRated =[];
  List _favourites = [];

  List get comics => _comics;
  List get characters => _characters;
  List get topRated => _topRated;
  List get favourites => _favourites;

  void setComics(List comics){
    _comics=comics;
    notifyListeners();
  }
  void setCharacters(List characters){
    _characters = characters;
    notifyListeners();
  }
  void setTopComics(List topRated){
    _topRated = topRated;
    notifyListeners();
  }
  void setFavourites(List fav){
    _favourites = fav;
      // LocalStorage storage = LocalStorage();
    LocalStorage.storeList('favourites', fav);
    notifyListeners();
  }
}