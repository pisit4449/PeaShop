import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peashop/models/product_model.dart';
import 'package:peashop/models/user_model.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_image.dart';
import 'package:peashop/widget/show_progress.dart';
import 'package:peashop/widget/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;

  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowProductBuyerState createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readAPI();
  }

  Future<void> readAPI() async {
    String urlAPI =
        '${MyConstant.domain}/shoppingmall/getProductWhereidSeller.php?isAdd=true&idSeller=${userModel!.id}';
    await Dio().get(urlAPI).then(
      (value) {
        // print('### value ====> $value');

        if (value.toString() == 'null') {
          setState(() {
            haveProduct = false;
            load = false;
          });
        } else {
          for (var item in json.decode(value.data)) {
            ProductModel model = ProductModel.fromMap(item);

            String string = model.images;
            string = string.substring(1, string.length - 1);
            List<String> strings = string.split(',');
            int i = 0;
            for (var item in strings) {
              strings[i] = item.trim();
              i++;
            }
            listImages.add(strings);

            setState(() {
              haveProduct = true;
              load = false;
              productModels.add(model);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: load
          ? ShowProgress()
          : haveProduct!
              ? listProducts()
              : Center(
                  child: ShowTitle(
                  title: 'No Products',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  LayoutBuilder listProducts() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // print('### You Click Index ====> $index');
            showAlertDialog(
              productModels[index],
              listImages[index],
            );
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5 - 8,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: findUrlImage(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.image1),
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                            title: productModels[index].name,
                            textStyle: MyConstant().h2Style()),
                        ShowTitle(
                            title: 'ราคา : = ${productModels[index].price} บาท',
                            textStyle: MyConstant().h3Style()),
                        ShowTitle(
                            title:
                                cutWord('รายละเอียด : = ${productModels[index].detail}'),
                            textStyle: MyConstant().h3Style()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingmall${strings[0]}';
    // print('### result ====> $result');
    return result;
  }

  Future<Null> showAlertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: ShowImage(path: MyConstant.image2),
                  title: ShowTitle(
                      title: productModel.name,
                      textStyle: MyConstant().h2Style()),
                  subtitle: ShowTitle(
                    title: 'ราคา: ${productModel.price} บาท',
                    textStyle: MyConstant().h3Style(),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${MyConstant.domain}/shoppingmall${images[indexImage]}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 0;
                                    print('### indexImage ====> $indexImage');
                                  });
                                },
                                icon: Icon(Icons.filter_1)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 1;
                                    print('### indexImage ====> $indexImage');
                                  });
                                },
                                icon: Icon(Icons.filter_2)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 2;
                                    print('### indexImage ====> $indexImage');
                                  });
                                },
                                icon: Icon(Icons.filter_3)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 3;
                                    print('### indexImage ====> $indexImage');
                                  });
                                },
                                icon: Icon(Icons.filter_4)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: 'รายละเอียด : ',
                              textStyle: MyConstant().h2Style()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(width: 200,
                              child: ShowTitle(
                                  title: productModel.detail,
                                  textStyle: MyConstant().h3Style()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  String cutWord(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 100);
      result = '$result .......';
    }
    return result;
  }
}
