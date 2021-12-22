
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  const UserProductItem({Key key, this.imageUrl, this.title, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);}),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () async {
              try{
               await Provider.of<ProductsProvider>(context,listen: false).deleteProduct(id);

              }catch (error){
                scaffold.showSnackBar(SnackBar(content: Text("Deleting failed"  ,textAlign: TextAlign.center,)));
              }
                  }),
            ],
          )),
    );
  }
}
