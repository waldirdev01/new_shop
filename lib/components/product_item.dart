import 'package:flutter/material.dart';
import 'package:new_shop/models/cart.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../utils/app_routes.dart';


class ProductItem extends StatelessWidget {
// Todo 03: o product que era passado via construtuor, agora vai via provider
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO 03.1
    final product = Provider.of<Product>(context, listen: false); // isso faz com que o provider não reaja à mudanças
    // apenas os widgets filhos do consumer vão reagir. Poderia colocar o Consumer envolvendo o ClipRRect, mas
    // aí seria a mesma coisa de deixar o provider ouvindo as alterações.
    //TODO 04: usando o parâmetro listen: false e Widget Consumer.
    //TODO 05: provider do cart
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            //Esse _ abaixo substitui um child que pode ser um Widget que seria passado
            //como filho do consumer que não receberia alterações
            builder: (context, product, _) {
              return IconButton(
                onPressed: () {
                  product.toggleFavorite();
                },
                //depois do consumer a cor não respondeu mais ao Theme
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
              );
            }
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
            },
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
        ),
      ),
    );
  }
}
