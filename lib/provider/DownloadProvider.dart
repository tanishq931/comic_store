import 'package:flutter/cupertino.dart';

class DownloadProvider extends ChangeNotifier{
  List _downloadedComics = [];

  List get downloadedComics => _downloadedComics;

  void addComic(var comic){
    _downloadedComics.add(comic);
    notifyListeners();
  }
  void removeComic(var id){
     _downloadedComics.removeWhere((val) {
       return val.id == id;
     });
     notifyListeners();
  }
  void setComicList(var list){
    _downloadedComics = list;
    notifyListeners();
  }

}