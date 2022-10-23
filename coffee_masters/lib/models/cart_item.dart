import 'package:coffee_masters/models/product.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
