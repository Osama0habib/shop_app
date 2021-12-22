import 'dart:convert';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/widget/full_screen_image_view.dart';
// import 'package:field_suggestion/field_suggestion.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var isSelected = false;
  var mycolor = Colors.white;
  var _submittedForm =
      Product(id: null, title: "", description: "", imageUrl: [], price: 0);
  var _initValues = {
    "title": "",
    "description": "",
    "imageUrl": [],
    "price": ""
  };
  var isInit = true;
  var isLoading = false;
  List<String> categoryList = [];

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // _imageUrlFocusNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _submittedForm = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _submittedForm.title,
          "description": _submittedForm.description,
          "imageUrl": _submittedForm.imageUrl,
          "price": _submittedForm.price.toString()
        };
        // _imageUrlController.text = _submittedForm.imageUrl;
      }
    }
    isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if ((!_imageUrlController.text.startsWith("http") &&
  //             !_imageUrlController.text.startsWith("https")) ||
  //         (!_imageUrlController.text.endsWith(".jpg") &&
  //             !_imageUrlController.text.endsWith(".png") &&
  //             !_imageUrlController.text.endsWith(".jpeg"))) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  var _image = [];
  Set<String> selectedImages = {};

  final picker = ImagePicker();

  // Widget check(){
  //   if(_submittedForm.imageUrl.isEmpty && _image.isEmpty) {
  //     return SizedBox();
  //   }else {
  //     setState(() {
  //       _submittedForm.imageUrl.forEach((element) {_image.add(element as String);});
  //
  //       print(_image);
  //     });
  //
  //     return Container(
  //       height: 200,
  //       width: double.infinity,
  //       child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: _image.length,
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (
  //               ctx,
  //               index,
  //               ) =>
  //               Container(
  //                   height: 100,
  //                   width: 100,
  //                   margin: EdgeInsets.only(
  //                       top: 8, right: 10),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                         width: 1, color: Colors.grey),
  //                   ),
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pushNamed(
  //                           FullScreenImageView
  //                               .routeName,
  //                           arguments: [_image, index]);
  //                     },
  //                     child: FittedBox(
  //                       child:_image[index] is File ? Image.file(
  //                         File(_image[index].path),
  //                         fit: BoxFit.cover,
  //                       )
  //                           : Image.network(
  //                           _submittedForm
  //                               .imageUrl[
  //                           index]),
  //                     ),
  //                   ))),
  //     );
  //   }
  // }
  void toggleSelection() {
    setState(() {
      // if (isSelected) {
      //   mycolor = Colors.white;
      //   isSelected = false;
      // } else {
      //   mycolor = Colors.grey[300];
      //   isSelected = true;
      // }
    });
  }

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getMultiImage();
    if (pickedImage != null) {
      setState(() {
        _image.isEmpty ? _image = pickedImage : _image.addAll(pickedImage);
        print(_image);
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_submittedForm.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_submittedForm.id, _submittedForm);
    } else {
      try {
        final prodProv = Provider.of<ProductsProvider>(context, listen: false);

        _submittedForm = Product(
            id: _submittedForm.id,
            description: _submittedForm.description,
            title: _submittedForm.title,
            price: _submittedForm.price,
            isFavorite: _submittedForm.isFavorite,
            imageUrl: await prodProv.uploadFiles(_image));
        await prodProv.addProduct(_submittedForm);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("An error occured!"),
                content: Text("Something went wrong!"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Okey"))
                ],
              );
            });
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_submittedForm.imageUrl.isNotEmpty) {
      _image = _submittedForm.imageUrl;
    }

    print(_initValues);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              onSubmitted:
                                  (category) {
                                if (categoryList.contains(category)) {
                                  return;
                                } else {
                                  categoryList.add(category);
                                }
                              },
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder())),
                          suggestionsCallback:
                              (category) => categoryList,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              title: Text(categoryList[index]),
                            );
                          },
                          onSuggestionSelected: (suggestion) {},
                        ),
                        // FieldSuggestion.builder(suggestionList: categoryList,onFieldChanged: (result) {
                        //   if(categoryList.contains(result)){
                        //     return;
                        //   }else {
                        //     categoryList.add(result);
                        //   }
                        // },
                        // textController: _categoryController,
                        // itemBuilder: (ctx, index) =>
                        //     Card(elevation: 10, child: Text(categoryList[index]),),),
                        TextFormField(
                          initialValue: _initValues["title"],
                          decoration: InputDecoration(
                            labelText: "Title",
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _submittedForm = Product(
                                id: _submittedForm.id,
                                title: value,
                                description: _submittedForm.description,
                                imageUrl: _submittedForm.imageUrl,
                                price: _submittedForm.price,
                                isFavorite: _submittedForm.isFavorite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter a title for product";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues["price"],
                          decoration: InputDecoration(
                            labelText: "Price",
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (value) {
                            _submittedForm = Product(
                                id: _submittedForm.id,
                                title: _submittedForm.title,
                                description: _submittedForm.description,
                                imageUrl: _submittedForm.imageUrl,
                                price: double.parse(value),
                                isFavorite: _submittedForm.isFavorite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter a Price for product";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please add  a valid price";
                            }
                            if (double.parse(value) <= 0) {
                              return "price must be morethan 0";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues["description"],
                          decoration: InputDecoration(
                            labelText: "Description",
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _submittedForm = Product(
                                id: _submittedForm.id,
                                title: _submittedForm.title,
                                description: value,
                                imageUrl: _submittedForm.imageUrl,
                                price: _submittedForm.price,
                                isFavorite: _submittedForm.isFavorite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter up to three lines of description";
                            }
                            if (value.length < 10) {
                              return "description must be at least 10 characters";
                            }
                            return null;
                          },
                        ),
                        // check(),
                        Card(
                          elevation: 15,
                          color: Color(0xff0499f2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _image.isEmpty
                                    ? SizedBox()
                                    : Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _image.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (
                                              ctx,
                                              index,
                                            ) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(
                                                        top: 8, right: 10),
                                                    decoration: BoxDecoration(
                                                      color: selectedImages
                                                              .contains(
                                                                  _image[index])
                                                          ? Colors.green
                                                          : Colors.white,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                FullScreenImageView
                                                                    .routeName,
                                                                arguments: [
                                                              _image,
                                                              index
                                                            ]);
                                                      },
                                                      onLongPress: () {
                                                        if (selectedImages
                                                                .contains(_image[
                                                                    index]) ==
                                                            false)
                                                          selectedImages.add(
                                                              _image[index]);
                                                        else
                                                          selectedImages.remove(
                                                              _image[index]);
                                                        setState(() {
                                                          if (selectedImages
                                                              .contains(_image[
                                                                  index])) {
                                                            toggleSelection();
                                                          }
                                                        });
                                                      },
                                                      child: FittedBox(
                                                          child: _image[index]
                                                                  is PickedFile
                                                              ? Image.file(
                                                                  File(_image[
                                                                          index]
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  _image[index],
                                                                )),
                                                    ))),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: GestureDetector(
                                    onTap: _openImagePicker,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 50,

                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      //  ListView.builder(itemCount: _image.length,itemBuilder: (ctx ,index ) => FittedBox(
                                      // child:Image.file(File(_image[index].path),fit: BoxFit.cover,) )
                                      //     ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
