import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/screen/edit_profile.dart';
import 'package:shop_app/widget/app_Drawer.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile_screen_edite";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50)),
                    color: Theme.of(context).primaryColor),
                padding: EdgeInsets.only(top: 50, bottom: 30),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "assets/fonts/Lato-Bold.ttf"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Username",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "assets/fonts/Lato-Bold.ttf"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 250),
                  width: 380,
                  height: 800,
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Contact",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "assets/fonts/Lato-Bold.ttf"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Phone : ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "assets/fonts/Lato-Bold.ttf"),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Store : ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "assets/fonts/Lato-Bold.ttf"),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Address : ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "assets/fonts/Lato-Bold.ttf"),
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingBar(
                                ratingWidget: RatingWidget(
                                    full: Icon(Icons.star),
                                    empty: Icon(Icons.star_border),
                                    half: Icon(Icons.star_half)),
                                onRatingUpdate: (rate) {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 8),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                              },
                              elevation: 10,
                              height: 40,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 8,),
                                  Icon(Icons.edit_outlined,color: Colors.white,)
                                ],
                              ),
                              color: Colors.blueGrey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              color: Colors.blueGrey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Reviews",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "assets/fonts/Lato-Bold.ttf"),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(),
                                    title: Text(
                                      "CustomerName",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Divider(color: Colors.blueGrey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 8),
                                    child: Text(
                                      "very good product",
                                      softWrap: true,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
