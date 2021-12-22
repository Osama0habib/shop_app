// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// class ImageSlider extends StatefulWidget {
//   @override
//   _ImageSliderState createState() => _ImageSliderState();
// }
//
// class _ImageSliderState extends State<ImageSlider> {
//
// final _products = product.imageUrl.map((item) => Container(
// child: Container(
// // margin: EdgeInsets.all(5.0),
// child: ClipRRect(
// borderRadius: BorderRadius.all(Radius.circular(5.0)),
// child: Stack(
// children: <Widget>[
// Image.network(item, fit: BoxFit.cover, width: double.infinity),
// Positioned(
// bottom: 0.0,
// left: 0.0,
// right: 0.0,
// child: Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Color.fromARGB(200, 0, 0, 0),
// Color.fromARGB(0, 0, 0, 0)
// ],
// begin: Alignment.bottomCenter,
// end: Alignment.topCenter,
// ),
// ),
// padding: EdgeInsets.symmetric(
// vertical: 0, horizontal: 5.0),
// child: Text(
// 'No. ${product.imageUrl.indexOf(item)} image',
// style: TextStyle(
// color: Colors.white,
// fontSize: 20.0,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ),
// ],
// )),
// ),
// ))
//     .toList(),
//
//
//
//  @override
//   Widget build(BuildContext context) {
//    int _current = 0;
//    final CarouselController _controller = CarouselController();
//     return Container(
//       child: CarouselSlider(
//           carouselController: _controller,
//           options: CarouselOptions(
//               autoPlay: false,
//               aspectRatio: 1,
//               enlargeCenterPage: true,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });}
//
//           ),
//           items: _products
//       ));
//
//   }
// }
