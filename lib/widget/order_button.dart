import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screen/order_screen.dart';
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed:(widget.cart.totalPrice <= 0 || isLoading)? null : ()async {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.item.values.toList(),
            double.parse(widget.cart.totalPrice.toStringAsFixed(2)));
        Navigator.of(context).pushNamed(OrderScreen.routeName);
        setState(() {
          isLoading =false;
        });
        widget.cart.clearCart();

      },
      child:isLoading? CircularProgressIndicator(): Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}