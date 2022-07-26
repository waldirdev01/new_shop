import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_shop/models/product.dart';

import '../data/dummy_data.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://newshopp-46acb-default-rtdb.firebaseio.com';
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
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

  Future<void> addProduct(Product product) {
    //converti para Future<void> para fazer o programa esperar enquanto adciona um produto
    final future = http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    ); // cria uma coleção products no realtimedatabase e adiciona o produto (sem o id)
    return future.then<void>((response) {
      //adicionando o generics void é como se tivesse colocado outro then quando esse then termina
      final id = jsonDecode(response.body)['name'];
      _items.add(Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));
      notifyListeners(); //recebe as informações de volta do RTDB e cria um produto com o id que veio do RTDB
    });
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
