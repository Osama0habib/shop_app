
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screen/home_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';
import 'package:shop_app/shared/shared_widgets.dart';
import 'package:shop_app/widget/app_Drawer.dart';

import '../widget/products_gridview.dart';

enum filterOption { AllProduct, FavoriteOnly }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorite = false;
  bool _isInit = true;

  bool isLoading = false;


  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (!mounted) return;

      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int _page = 0;
  String _title = "Product";
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController(initialPage: 0, );
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: defaultAppBar(context: context, title: _title),
        bottomNavigationBar: CurvedNavigationBar(color: Theme.of(context).primaryColor ,backgroundColor: Colors.transparent,buttonBackgroundColor: Theme.of(context).primaryColor,
          key: _bottomNavigationKey,
          height:50 ,
          index: _page,

          items: <Widget>[
            Icon(Icons.home, size: 30,color: Colors.white,),
            Icon(Icons.circle, size: 30,color: Colors.white,),
            Icon(Icons.favorite, size: 30,color: Colors.white,),
          ],
          onTap: (index) {
            setState(() {
              _pageController.jumpToPage(index);


            });
          },
        ),extendBodyBehindAppBar: false,
        drawer: AppDrawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : PageView(controller: _pageController,onPageChanged: (page) {
          String _temptitle = "";
          switch (page) {
            case 0:
              _temptitle = "Home";
              break;
            case 1:
              _temptitle = "shop";
              break;
            case 2:
              _temptitle = "Favorite";
              break;
          }
          setState(() {
            this._title = _temptitle;

            this._page = page;
          });
        },
                children: [
                  HomeScreen(),
                  ProductsGridView(false),
                  ProductsGridView(true),
                ],
              ));
  }
}
