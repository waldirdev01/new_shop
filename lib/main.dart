import 'package:flutter/material.dart';
import 'package:new_shop/models/cart.dart';
import 'package:new_shop/models/product_list.dart';
import 'package:new_shop/pages/product_detail_page.dart';
import 'package:new_shop/pages/products_overview_page.dart';
import 'package:new_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //Aqui foi criado um changenotifier para productList
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.copyWith(
          primaryColor: const Color(0x00ff0000),
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: const Color(0XFE1b1b2b),
          ),
        ),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
        },
        home: ProductsOverviewPage(),
      ),
    );
  }
}
