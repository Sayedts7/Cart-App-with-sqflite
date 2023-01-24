 import 'package:database_test/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart ;
  Future<List<Cart>> get cort => _cart ;

  Future<List<Cart>> getData () async {
    _cart = db.getCartList();
    return _cart ;
  }

  void _setPrefsItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', 0);
    notifyListeners();
  }

  void _getPrefsItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice){

    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice(){
    _getPrefsItems();
    return _totalPrice;
  }


    void addCounter(){
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }


  void removeCounter(){
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter(){
    _getPrefsItems();
    return _counter;
  }
}