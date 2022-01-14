import 'package:flutter/material.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/widget/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typUser;

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name :',
              prefixIcon: Icon(
                Icons.fingerprint,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Address :',
              hintStyle: MyConstant().h3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(
                  Icons.home,
                  color: MyConstant.dark,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Phone :',
              prefixIcon: Icon(
                Icons.phone,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User :',
              prefixIcon: Icon(
                Icons.perm_identity,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.lock,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: MyConstant.light),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text('Create New Account'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildTitle('ข้อมูลทั่วไป'),
            buildName(size),
            buildTitle('เลือก User :'),
            buildRadioBuyer(size),
            buildRadioSeller(size),
            buildRadioRider(size),
            buildTitle('ข้อมูลพื้นฐาน'),
            buildAddress(size),
            buildPhone(size),
            buildUser(size),
            buildPassword(size),
            buildTitle('รูปภาพ'),
            buildSubTitle(),
          ],
        ),
      ),
    );
  }

  ShowTitle buildSubTitle() => ShowTitle(
        title: 'รูปภาพของคุณ(ไม่บังคับ)',
        textStyle: MyConstant().h3Style(),
      );

  Row buildRadioBuyer(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Buyer',
            groupValue: typUser,
            onChanged: (value) {
              setState(() {
                typUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผู้ซื้อ(Buyer)',
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioSeller(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Seller',
            groupValue: typUser,
            onChanged: (value) {
              setState(() {
                typUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผู้ขาย(seller)',
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioRider(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Rider',
            groupValue: typUser,
            onChanged: (value) {
              setState(() {
                typUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผู้ส่ง(Rider)',
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
