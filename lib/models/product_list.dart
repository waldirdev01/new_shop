import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_shop/models/product.dart';

import '../data/dummy_data.dart';

class ProductList with ChangeNotifier {
  final _url = 'https://newshopp-46acb-default-rtdb.firebaseio.com/products.json';
  List<Product> _items = [];

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }
  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse(_url));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });
    notifyListeners();
  }
  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;
//converti para Future<void> para poder utilizar o asssinconismo para o programa
    //esperar enquanto salva ou atualiza um produto
    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
    //provisório. Ainda não entendi para que serve
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((element) => element.id == product.id);
      notifyListeners();
    }
  }

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_url'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));
    notifyListeners();
  }
}

// bool _showFavoriteOnly = false;

// List<Product> get items {
//   if (_showFavoriteOnly) {
//     return _items.where((prod) => prod.isFavorite).toList();
//   }
//   return [..._items];
// }

// void showFavoriteOnly() {
//   _showFavoriteOnly = true;
//   notifyListeners();
// }

// void showAll() {
//   _showFavoriteOnly = false;
//   notifyListeners();
// }
