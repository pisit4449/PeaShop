import 'package:flutter/material.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuthen, (route) => false),
                );
          },
          tileColor: Colors.red.shade900,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sig Out',
            textStyle: MyConstant().h2WhiteStyle(),
          ),
          subtitle: ShowTitle(
            title: 'Sign Out And Go to Authen',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }
}