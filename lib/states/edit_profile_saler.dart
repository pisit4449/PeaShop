import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peashop/models/user_model.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_image.dart';
import 'package:peashop/widget/show_progress.dart';
import 'package:peashop/widget/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSaler extends StatefulWidget {
  const EditProfileSaler({Key? key}) : super(key: key);

  @override
  _EditProfileSalerState createState() => _EditProfileSalerState();
}

class _EditProfileSalerState extends State<EditProfileSaler> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('user')!;

    String apiGetUser =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiGetUser).then((value) => {
          // print('## value from API ==> $value');
          for (var item in json.decode(value.data))
            {
              setState(() {
                userModel = UserModel.fromMap(item);
                nameController.text = userModel!.name;
                addressController.text = userModel!.address;
                phoneController.text = userModel!.phone;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is EditProfileSaller'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildTitle('General :'),
            buildName(constraints),
            buildAddress(constraints),
            buildPhone(constraints),
            buildTitle('Avatar'),
            buildAvatar(constraints),
            buildTitle('Location'),
          ],
        ),
      ),
    );
  }

  Row buildAvatar(BoxConstraints constraints) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: MyConstant.dark),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_a_photo,
                        color: MyConstant.dark,
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.6,
                      height: constraints.maxWidth * 0.6,
                      child: userModel == null
                          ? ShowProgress()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: userModel!.avatar == null
                                  ? ShowImage(path: MyConstant.avatar)
                                  : CachedNetworkImage(
                                      imageUrl:
                                          '${MyConstant.domain}${userModel!.avatar}',
                                      placeholder: (context, url) =>
                                          ShowProgress(),
                                    ),
                            ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_a_photo,
                        color: MyConstant.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            maxLines: 4,
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }


}
