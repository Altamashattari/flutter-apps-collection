import 'dart:convert';

import 'package:http/http.dart' as httpRequest;

import 'package:coffee_masters/models/cart_item.dart';
import 'package:coffee_masters/models/category.dart';
import 'package:coffee_masters/models/product.dart';

class DataManager {
  List<Category>? _menu;
  List<CartItem> cart = [];

  addToCart(Product p) {
    bool found = false;
    for (var item in cart) {
      if (item.product.id == p.id) {
        item.quantity++;
        found = true;
        break;
      }
    }
    if (!found) {
      cart.add(CartItem(product: p, quantity: 1));
    }
  }

  removeFromCart(Product p) {
    cart.removeWhere((item) => item.product.id == p.id);
  }

  clearCart() {
    cart.clear();
  }

  double cartTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.quantity * item.product.price;
    }
    return total;
  }

  fetchMenu() async {
    const url = "https://firtman.github.io/coffeemasters/api/menu.json";
    var response = await httpRequest.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = response.body;
      _menu = [];
      var decodeData = jsonDecode(body) as List<dynamic>;
      for (var json in decodeData) {
        _menu?.add(Category.fromJson(json));
      }
    }
  }

  Future<List<Category>> getMenu() async {
    if (_menu == null) {
      await fetchMenu();
    }
    return _menu!;
  }
}
