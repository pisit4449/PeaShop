import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peashop/utility/my_constant.dart';
import 'package:peashop/utility/my_dialog.dart';
import 'package:peashop/widget/show_image.dart';
import 'package:peashop/widget/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => processAddProduct(),
              icon: Icon(Icons.cloud_upload))
        ],
        title: Text("Add Product"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildPriceProduct(constraints),
                    buildProductDetail(constraints),
                    buildImage(constraints),
                    addProductButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        // print('## choose 4 image success');

        MyDialog().showProgressDiaLog(context);

        String apiSaveProduct =
            '${MyConstant.domain}/shoppingmall/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000000);
          String nameFile = 'product$i.jpg';

          paths.add('/product/$nameFile');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then((value) async {
            print('Upload Success');
            loop++;
            if (loop >= files.length) {
              SharedPreferences preference =
                  await SharedPreferences.getInstance();

                  String idSeller = preference.getString('id')!;
                  String nameSeller = preference.getString('name')!;
                  String name = nameController.text;
                  String price = priceController.text;
                  String detail = detailController.text;
                  String images = paths.toString();
                  print('#### idSeller = $idSeller, nameSeller = $nameSeller');
                  print('### name = $name, price = $price, detail = $detail');
                  print('### images ==>> $images');

                  String path = '${MyConstant.domain}/shoppingmall/insertProduct.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&name=$name&price=$price&detail=$detail&images=$images';

                  await Dio().get(path).then((value) => Navigator.pop(context));
                  
              Navigator.pop(context);
            }
          });
        }
      } else {
        MyDialog()
            .normalDialog(context, 'More Image', 'Please Choose More Image');
      }
    }
  }

  Future<Null> prodessImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click From index ==>> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(
            title: 'Source Image ${index + 1} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'Please Tab on Camera or Gallery',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  prodessImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  prodessImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallary'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          height: constraints.maxWidth * 0.75,
          width: constraints.maxWidth * 0.75,
          child:
              file == null ? Image.asset(MyConstant.image6) : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.image6)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'Name Product :',
          prefixIcon: Icon(
            Icons.production_quantity_limits_sharp,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildPriceProduct(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(controller: priceController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Price in Blank';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'Price Product :',
          prefixIcon: Icon(
            Icons.price_change,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Detail in Blank';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          hintStyle: MyConstant().h3Style(),
          hintText: 'Product Detail :',
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Icon(
              Icons.details_outlined,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
