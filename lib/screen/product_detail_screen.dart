import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/shared/shared_widgets.dart';
import 'package:shop_app/widget/full_screen_image_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/widget/product_item.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // ProductDetailScreen( this.title);
  static const routeName = '/product_detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final halfDeviceSize = deviceSize.width / 2;
    final productId = ModalRoute.of(context).settings.arguments as String;

    final authData = Provider.of<Auth>(context,listen: false);
    final product = Provider.of<ProductsProvider>(context,listen: false);
    final loadedProduct = product
        .findById(productId);
    return Scaffold(
      persistentFooterButtons: [
    Consumer<Cart>(
    builder: (ctx, cart, _) =>
        MaterialButton(
          elevation: 20,
          minWidth: double.infinity * 0.75,
          height: 50,
          color: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            cart.addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "product \ ${loadedProduct.title} added to cart ${cart.item[loadedProduct.id].quantity} \X"),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Undo',
                textColor: Theme.of(context).accentColor,
                onPressed: () {
                  cart.removeSingleItem(loadedProduct.id);
                },
              ),
            ));
          },
          child: Text(
            "Add To Cart",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // style:
          //     ButtonStyle(elevation: MaterialStateProperty.all<double>(20),
          //     backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
          //     ),
        )
    )],
      appBar: defaultAppBar(context: context, title: loadedProduct.title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(clipBehavior: Clip.none, children: [
                Hero(
                  tag: loadedProduct.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: 300,
                      child: CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                            height: double.infinity,
                            viewportFraction: 1,
                            autoPlay: false,
                            aspectRatio: 1,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        items: loadedProduct.imageUrl
                            .map((item) => Container(
                                  width: double.infinity,
                                  // margin: EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          FullScreenImageView.routeName,
                                          arguments: [
                                            loadedProduct.imageUrl,
                                            _current
                                          ]);
                                    },
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    bottom: -25,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        icon: Icon(
                          loadedProduct.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          setState(() {
                            loadedProduct.toggleFavorite(
                                authData.token, authData.userId);
                          });
                        },
                      ),
                    ))
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: loadedProduct.imageUrl.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: halfDeviceSize / loadedProduct.imageUrl.length,
                    height: 5,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Title : ",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          loadedProduct.title,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Category : ",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "People",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "Price",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 15),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "EGP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontFamily: "assets/fonts/Lato-Bold.ttf"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${loadedProduct.price.toString()}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: "assets/fonts/Lato-Bold.ttf"),
                          ),
                        ],
                      ),
                      RatingBar(
                        itemSize: 30,
                        onRatingUpdate: (double value) {},
                        ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                            ),
                            half: Icon(
                              Icons.star_half_outlined,
                              color: Colors.yellow[700],
                            ),
                            empty: Icon(
                              Icons.star_border,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        loadedProduct.description,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Row(
                    children: [
                      Text(
                        "Sold By : ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "assets/fonts/Lato-Bold.ttf",
                            fontSize: 20),
                      ),
                      Text(loadedProduct.sellerName)
                    ],
                  ),
                  subtitle: RatingBar(
                    itemSize: 25,
                    onRatingUpdate: (double value) {},
                    ratingWidget: RatingWidget(
                        full: Icon(Icons.star, color: Colors.yellow[700]),
                        half: Icon(Icons.star_half_outlined,
                            color: Colors.yellow[700]),
                        empty: Icon(Icons.star_border)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Text(
                      "Most Match",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      // width: deviceSize.width -10,
                      height: 200,
                      child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                        itemCount: product.item.length -1,
                        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(value: product.item.where((element) => element != loadedProduct).toList()[index],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(width: deviceSize.width /3 - 8,
                              child: ProductItem()),
                        ),)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
