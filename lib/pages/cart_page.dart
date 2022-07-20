import 'package:flutter/material.dart';
import 'package:new_shop/models/cart.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    child: Text('COMPRAR'),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(items[i]),
            ),
          )
        ],
      ),
    );
  }
}
