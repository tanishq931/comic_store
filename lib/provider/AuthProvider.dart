import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isAdmin = false;
  String _email = '';
  String _uid = '';
  List _favouritesList = [];

  bool get isAdmin => _isAdmin;
  String get email => _email;
  String get uid => _uid;
  List  get favouritesList => _favouritesList;

  void setData(var data){
    _email=data['email'];
    _uid=data['id'];
    _isAdmin = data['role']=='ADMIN';
    _favouritesList = favouritesList;
    notifyListeners();
  }
  void setFavouritesList(List list){
    _favouritesList= list;
    notifyListeners();
  }
  void clearData(){
    _isAdmin=false;
    _email='';
    _uid='';
    _favouritesList=[];


  }
}
