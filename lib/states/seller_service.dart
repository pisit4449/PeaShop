// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:peashop/bodys/shop_manage_seller.dart';
import 'package:peashop/bodys/show_order_seller.dart';
import 'package:peashop/bodys/show_product_seller.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_signout.dart';
import 'package:peashop/widget/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [
    ShowOrderSeller(),
    ShowManageSeller(),
    ShowProductSeller(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduce(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
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
