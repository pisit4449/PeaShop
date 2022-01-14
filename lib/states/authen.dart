import 'package:flutter/material.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_image.dart';
import 'package:peashop/widget/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            buildImage(size),
            buildTitle(),
          ],
        ),
      ),
    );
  }

  Row buildTitle() {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowTitle(
                title: MyConstant.appName,
                textStyle: MyConstant().h1Style(),
              ),
            ],
          );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: ShowImage(path: MyConstant.image4),
        ),
      ],
    );
  }
}
