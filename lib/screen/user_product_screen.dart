import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/widget/app_Drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product';

  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(persistentFooterButtons: [MaterialButton(elevation: 20,
      minWidth: double.infinity * 0.75,
      height: 50,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        Navigator.of(context).pushNamed(EditProductScreen.routeName);

      },
      child: Text("Add more ads",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
      // style:
      //     ButtonStyle(elevation: MaterialStateProperty.all<double>(20),
      //     backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      //     ),
    )],
      appBar: AppBar(
        title: Text("Your Ads"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),

      // appBar: AppBar(
      //   title: Text('User Product'),
      //   actions: [IconButton(icon: Icon(Icons.add), onPressed: () {
      //     Navigator.of(context).pushNamed(EditProductScreen.routeName);
      //   })
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: FutureBuilder(
                  future: refreshProduct(context),
                  builder: (ctx, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => refreshProduct(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<ProductsProvider>(
                                builder: (ctx, product, _) => ListView.builder(
                                    itemCount: product.item.length,
                                    itemBuilder: (_, i) => Column(
                                          children: [
                                            UserProductItem(
                                              id: product.item[i].id,
                                              title: product.item[i].title,
                                              imageUrl:
                                                  product.item[i].imageUrl[0],
                                            ),
                                            Divider(color: Colors.grey,),
                                          ],
                                        ))),
                          ),
                        ),
                ),
              ),
            ),
          ),

        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
