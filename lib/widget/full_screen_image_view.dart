import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageView extends StatefulWidget {
  static const routeName = "/full_screen_image_view";

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as List;
    var image = arg[0];
    int _current = arg[1];
    PageController _pageController = PageController(initialPage: _current);
    PhotoViewController _photoViewController = PhotoViewController();

    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                scrollPhysics: const BouncingScrollPhysics(),
                itemCount: image.length,
                builder: (ctx, index) {
                  return PhotoViewGalleryPageOptions(
                    // key: Key(image[index]),
                    imageProvider: image[index] is PickedFile ?Image.file(File(image[index].path)).image : Image.network(image[index]).image,
                    controller: _photoViewController,

                  );

                },
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
