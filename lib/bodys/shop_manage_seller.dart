import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peashop/models/user_model.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_progress.dart';
import 'package:peashop/widget/show_title.dart';

class ShowManageSeller extends StatefulWidget {
  final UserModel userModel;
  const ShowManageSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowManageSellerState createState() => _ShowManageSellerState();
}

class _ShowManageSellerState extends State<ShowManageSeller> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState

    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('## refreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereid.php?isAdd=true&id=${userModel!.id}';
        await Dio().get(apiGetUserWhereId).then((value) {
           for (var item in json.decode(value.data)) {
             setState(() {
               userModel = UserModel.fromMap(item);
             });
           }
             
           } 
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        child: Icon(Icons.edit),
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeEditProfileSaler)
                .then((value) => refreshUserModel()),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowTitle(
                    title: 'Name Shop :', textStyle: MyConstant().h2Style()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowTitle(
                          title: userModel!.name,
                          textStyle: MyConstant().h1Style()),
                    ),
                  ],
                ),
                ShowTitle(
                    title: 'Address :', textStyle: MyConstant().h2Style()),
                // ignore: sized_box_for_whitespace
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShowTitle(
                          title: userModel!.address,
                          textStyle: MyConstant().h2Style(),
                        ),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                  title: 'Phone : ${userModel!.phone}',
                  textStyle: MyConstant().h2Style(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ShowTitle(
                    title: 'Avatar',
                    textStyle: MyConstant().h2Style(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: constraints.maxWidth * 0.6,
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                    ),
                  ],
                ),
                ShowTitle(
                  title: 'Location :',
                  textStyle: MyConstant().h2Style(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: constraints.maxWidth * 0.8,
                      height: constraints.maxWidth * 0.8,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(userModel!.lat),
                            double.parse((userModel!.lng)),
                          ),
                          zoom: 16,
                        ),
                        markers: <Marker>[
                          Marker(
                            markerId: MarkerId('id'),
                            position: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            infoWindow: InfoWindow(
                                title: 'You Here',
                                snippet:
                                    'lat = ${userModel!.lat}, lng = ${userModel!.lng}'),
                          ),
                        ].toSet(),
                        // markers: Set<Marker>[
                        //   Marker(markerId: 'id'),position: LatLng(double.parse(userModel!.lat),double.parse(userModel!.lng),),),
                        // ].toSet(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
