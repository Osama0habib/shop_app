import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/widget/badge.dart';

Widget defaultAppBar({@required context, @required title}) => AppBar(shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 20,
        title: Text("$title"),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          )
        ]);

Widget defaultSearchBar({@required context , @required controller ,@required onSearch }) => Container(
    margin: EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).accentColor,
    ),
    child: TextFormField(
      onChanged: onSearch,
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(prefixIcon: Icon(Icons.search),border: InputBorder.none),textAlignVertical: TextAlignVertical.center,enableSuggestions: true,
    ));

Widget customTextField({
  @required String label,
  prefixIcon,
  String initValue,
  TextEditingController controller,
  void Function(String) onSaved,
}) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      labelText: label,
      prefixIcon: Icon(prefixIcon),
    ),
    initialValue: initValue,
    controller: controller,
    onSaved:onSaved,

  ),
);
