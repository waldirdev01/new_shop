import 'package:flutter/material.dart';
import 'package:new_shop/components/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    required this.showFavoriteOnly,
  }) : super(key: key);
  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      //TODO 02: para perceber as reatividades via provider
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          //Aqui não foi criada, apenas recebe loadedproducts que já existia por isso a alteração para .value
          value: loadedProducts[i],
          child: ProducGridtItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
