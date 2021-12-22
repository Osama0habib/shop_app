import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widget/app_Drawer.dart';
import 'package:shop_app/widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/Order_Screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _futureOrders ;
  Future _obtainFutureOrders(){
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
    _futureOrders = _obtainFutureOrders();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Your Orders"),
        // ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _futureOrders,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text("An error occured"),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(order: orderData.orders[i])));
              }
            }
          },
        )
        // _isLoading
        //   ? Center(child: CircularProgressIndicator()) : ListView.builder(
        //   itemCount: orderData.orders.length,
        //   itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i],
        );
  }
}
