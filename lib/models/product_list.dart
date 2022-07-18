import 'package:flutter/material.dart';
import 'package:new_shop/models/product.dart';

import '../data/dummy_data.dart';


class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
