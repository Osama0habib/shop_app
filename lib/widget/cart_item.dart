import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  const CartItem({Key key,
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
       return showDialog(context: context, builder: (ctx) => AlertDialog(title: Text('Are you Sure'),
            content: Text('Do you want to remove that item from your cart'),
            actions: [
              FlatButton(onPressed: () {
                return Navigator.of(ctx).pop(false);
              }, child: Text('Cancel')),
              FlatButton(onPressed: () {
                return Navigator.of(ctx).pop(true);
              }, child: Text('Remove')),
            ],));
      },
      key: ValueKey(id),
      background: Container(
        color: Theme
            .of(context)
            .errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total ${price * quantity}"),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
