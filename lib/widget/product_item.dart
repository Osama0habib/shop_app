import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem({Key key, this.id, this.title, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final authData = Provider.of<Auth>(context);
    print(product.imageUrl[0].toString());
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id),
            child: Hero(
              tag: product.id,
                child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl[0].toString()),
              fit: BoxFit.cover,
            ),
            ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  product.toggleFavorite(authData.token, authData.userId);
                },
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (ctx, cart, _) => IconButton(
                icon: Icon(
                  cart.item.containsKey(product.id)
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "product \ ${product.title} added to cart ${cart.item[product.id].quantity} \X"),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Theme.of(context).accentColor,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
              ),
            )),
      ),
    );
  }
}
