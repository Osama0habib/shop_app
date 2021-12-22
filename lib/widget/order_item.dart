import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key key, this.order}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300,),
      height: _expand ? min(widget.order.product.length * 20.0 + 110, 200)  : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("${widget.order.amount}"),
              subtitle: Text(
                  DateFormat("dd mm yyyy hh:mm").format(widget.order.dateTime)),
              trailing: IconButton(
                  icon: Icon(_expand ? Icons.expand_less :Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expand = !_expand;
                      print(_expand);
                    });
                  }),
            ),
            // if (_expand)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                height: _expand ? min(widget.order.product.length * 20.0 + 10, 180) :0,
                child: ListView(
                  children: [
                    ...widget.order.product
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text('${prod.quantity}X ${prod.price} ')
                              ],
                            ))
                        .toList(),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
