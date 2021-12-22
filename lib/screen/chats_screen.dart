import 'package:flutter/material.dart';
import 'package:shop_app/screen/ptp_screen.dart';

class ChatsScreen extends StatelessWidget {
  // const ChatsScreen({Key? key}) : super(key: key);
  static const routeName = '/chats_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Chats"),

    ),
        body: ListView.builder(
            itemCount: 20,
            itemBuilder: (ctx, index) => ListTile(onTap: (){Navigator.of(context).pushNamed(PtpScreen.routeName);},
                  leading: CircleAvatar(),
              title: Text("UserName"),
              subtitle: Text("Last Massage"),
                )));
  }
}
