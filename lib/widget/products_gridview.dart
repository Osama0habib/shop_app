import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/shared/shared_widgets.dart';
import 'package:shop_app/widget/product_item.dart';

class ProductsGridView extends StatefulWidget {
  final bool showOnlyFavorite;

  ProductsGridView(this.showOnlyFavorite);

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<Product> products;

  bool _IsSearching;
  String _searchText = "";

  _ProductsGridViewState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  List<Product> _buildList() {
    return products;
  }

  List<Product> _buildSearchList() {
    if (_searchText.isEmpty) {
      return products;
    } else {
      List<Product> _searchList = List();
      _searchList = products
          .where((product) =>
              product.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _IsSearching = false;
    init();
  }

  void init() {
    products = List();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    setState(() {
      products =
          widget.showOnlyFavorite ? productData.favorite : productData.item;
    });

    void onSearch(value) {
      productData.getSearch(value);
    }

    return Scaffold(
      key: key,
      body: Column(
        children: [
          defaultSearchBar(
              context: context, controller: _searchQuery, onSearch: onSearch),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _IsSearching
                  ? productData.getSearch(_searchText).length
                  : products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemBuilder: (ctx, i) {
                return ChangeNotifierProvider.value(
                  value: productData.getSearch(_searchText)[i],
                  // create: (ctx) => products[i],
                  child: ProductItem(
                      // id: products[i].id,
                      // title: products[i].title,
                      // imageUrl: products[i].imageUrl,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
