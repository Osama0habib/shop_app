import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/screen/chats_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/edit_profile.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_detail_screen.dart';
import 'package:shop_app/screen/products_overview_screen.dart';
import 'package:shop_app/screen/profile_screen.dart';
import 'package:shop_app/screen/ptp_screen.dart';
import 'package:shop_app/screen/splash_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';
import 'package:shop_app/widget/full_screen_image_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Product(),
        // ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
        create: (ctx) => ProductsProvider(),
        update: (ctx,auth,products)  => products..update(auth.token, auth.userId , products.item),
        ),

        ChangeNotifierProvider.value(
          value : Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                  auth.token,
                  previousOrders == null ? [] : previousOrders.orders,
                  auth.userId,
                ),
        ),
      ],
      child:Consumer<Auth>(
        builder: (ctx, auth, child) =>  MaterialApp(
           debugShowCheckedModeBanner: false,
          title: "Shop App",
          theme: ThemeData(
            dividerColor: Colors.transparent,
              primaryColor: Colors.lightBlue[900],
              accentColor: Colors.blueGrey,
              fontFamily: 'Lato',accentTextTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
          home: auth.isAuth
              ? ProductsOverviewScreen()

              : FutureBuilder(
            future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          :auth.token== null? AuthScreen() : SplashScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            FullScreenImageView.routeName:(ctx) => FullScreenImageView(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            ChatsScreen.routeName : (ctx) => ChatsScreen(),
            PtpScreen.routeName :(ctx) => PtpScreen(),
            EditProfileScreen.routeName:(ctx) => EditProfileScreen(),

          },
      ),

      ));
  }
}
