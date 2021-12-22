import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/widget/order_button.dart';

import '../widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart_Screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text("${cart.totalPrice}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.item.length,
                  itemBuilder: (ctx, i) => CartItem(
                      id: cart.item.values.toList()[i].id,
                      title: cart.item.values.toList()[i].title,
                      price: cart.item.values.toList()[i].price,
                      quantity: cart.item.values.toList()[i].quantity)))
        ],
      ),
    );
  }
}


