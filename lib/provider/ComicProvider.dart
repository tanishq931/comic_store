import 'package:flutter/cupertino.dart';

class Comicprovider extends ChangeNotifier{
  List _comics = [];
  List _characters =[];
  List _topRated =[];

  List get comics => _comics;
  List get characters => _characters;
  List get topRated => _topRated;

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
}