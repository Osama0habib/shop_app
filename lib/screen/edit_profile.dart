import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/shared/shared_widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key key}) : super(key: key);
  static const routeName = "/edit_profile_screen";


  @override
  Widget build(BuildContext context) {


    return Scaffold(body:
    Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(50)),
              color: Theme.of(context).primaryColor),
          padding: EdgeInsets.only(top: 50, bottom: 30),
          child: Center(
            child: CircleAvatar(
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: ClipOval(child: Image.asset("assets/images/person.jpg")),
              ),
              radius: 40,
            ),
          ),
        ),
        customTextField(label: "Email Address",prefixIcon: Icons.alternate_email,initValue:  ),
        customTextField(label: "User name",prefixIcon: Icons.person,),
        customTextField(label: "User name",prefixIcon: Icons.person,),

      ],
    ),);
  }
}
