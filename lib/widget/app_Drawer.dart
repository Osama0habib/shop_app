import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screen/chats_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/profile_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // AppBar(backgroundColor: Color(0xff0499f2),
          //   title: Text("ShopApp"),centerTitle: true,
          //   automaticallyImplyLeading: false,
          // ),
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(
                            Icons.account_circle,
                            size: 100,
                          )),
                      radius: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "User Name",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Profile"),
            onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Setting Screen"),
            )),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("My Ads"),
            onTap: () => Navigator.of(context)
                .pushNamed(UserProductScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text("Chats"),
            onTap: () => Navigator.of(context)
        .pushNamed(ChatsScreen.routeName),
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text("About"),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("About Screen"),
            )),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
