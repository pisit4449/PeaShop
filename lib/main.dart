import 'package:flutter/material.dart';
import 'package:peashop/states/add_product.dart';
import 'package:peashop/states/authen.dart';
import 'package:peashop/states/buyer_service.dart';
import 'package:peashop/states/create_account.dart';
import 'package:peashop/states/edit_profile_saler.dart';
import 'package:peashop/states/rider_service.dart';
import 'package:peashop/states/seller_service.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct': (BuildContext context) => AddProduct(),
  '/editProfileSaler': (BuildContext context) => EditProfileSaler(),
};

String? initlalRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('## type ===>> $type');
  if (type?.isEmpty ?? true) {
    initlalRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'Buyer':
      initlalRoute = MyConstant.routeBuyerService;
      runApp(MyApp());
      break;
      case 'Seller':
      initlalRoute = MyConstant.routeSellerService;
      runApp(MyApp());
      break;
      case 'Rider':
      initlalRoute = MyConstant.routeriderService;
      runApp(MyApp());
      break;
      default:
       
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor = MaterialColor(0xff4c008f, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
