// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peashop/bodys/shop_manage_seller.dart';
import 'package:peashop/bodys/show_order_seller.dart';
import 'package:peashop/bodys/show_product_seller.dart';
import 'package:peashop/models/user_model.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_progress.dart';
import 'package:peashop/widget/show_signout.dart';
import 'package:peashop/widget/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id Login ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereid.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('## value ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          // print('## name logined = ${userModel!.name}');
          widgets.add(ShowOrderSeller());
          widgets.add(ShowManageSeller(userModel: userModel!));
          widgets.add(ShowProductSeller());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: widgets.length == 0 ? SizedBox() : Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                buildHead(),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduce(),
              ],
            ),
          ],
        ),
      ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
        otherAccountsPictures: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.face),
            iconSize: 36,
            color: MyConstant.light,
            tooltip: 'Edit Shop',
          ),
        ],
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [MyConstant.light, MyConstant.dark],
            center: Alignment(-0.8, -0.2),
            radius: 1,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant.domain}${userModel!.avatar}'),
        ),
        accountName: Text(userModel == null ? 'Name' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type ?' : userModel!.type));
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1),
      title: ShowTitle(title: 'Show Order', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของ Order ที่สั่ง',
          textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(title: 'Shop Manage', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดของร้านให้ลูกค้าเห็น',
          textStyle: MyConstant().h3Style()),
    );
  }

  ListTile menuShowProduce() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3),
      title:
          ShowTitle(title: 'Show Product', textStyle: MyConstant().h2Style()),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดสินค้าที่เราขาย',
          textStyle: MyConstant().h3Style()),
    );
  }
}
