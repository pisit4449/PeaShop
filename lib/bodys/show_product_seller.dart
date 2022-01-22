import 'dart:convert';
// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peashop/models/product_model.dart';
import 'package:peashop/states/edit_product.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_image.dart';
import 'package:peashop/widget/show_progress.dart';
import 'package:peashop/widget/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (productModels != 0) {
      productModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmall/getProductWhereidSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('### product = ${model.name}');

          setState(() {
            load = false;
            haveData = true;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'No Product',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'Please Add Products',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct).then(
          (value) => loadValueFromAPI(),
        ),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingmall${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowTitle(
                    title: productModels[index].name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  Container(
                      width: constraints.maxWidth * 0.5,
                      height: constraints.maxWidth * 0.4,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: createUrl(productModels[index].images),
                        placeholder: (context, url) => ShowProgress(),
                        errorWidget: (context, url, error) =>
                            ShowImage(path: MyConstant.image6),
                      )
                      // child: Image.network(
                      //   createUrl(productModels[index].images),
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                    title: 'Price: ${productModels[index].price} THB',
                    textStyle: MyConstant().h2Style(),
                  ),
                  ShowTitle(
                    title: productModels[index].detail,
                    textStyle: MyConstant().h3Style(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          print('You Click Edit');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                  productModel: productModels[index],
                                ),
                              )).then((value) => loadValueFromAPI());
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 36,
                          color: MyConstant.dark,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print('## You Click Delete! From index = $index');
                          confirmDialogDelete(productModels[index]);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 36,
                          color: MyConstant.dark,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(productModel.images),
            placeholder: (contex, Url) => ShowProgress(),
          ),
          title: ShowTitle(
            title: 'Delete ${productModel.name} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: productModel.detail,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('### Delete Product id ${productModel.id}');
              String aipDeleteProductWhereID =
                  '${MyConstant.domain}/shoppingmall/deleteProductWhereid.php?isAdd=true&id=${productModel.id}';
              await Dio().get(aipDeleteProductWhereID).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
              // Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}
