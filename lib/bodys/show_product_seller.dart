import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peashop/models/product_model.dart';
import 'package:peashop/utility/my_constant.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
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
              ? Text('Have Data')
              : Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'No Product', textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'Please Add Products',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct),
        child: Text('Add'),
      ),
    );
  }
}
