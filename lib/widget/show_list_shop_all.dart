import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eatporkshop/model/user_model.dart';
import 'package:eatporkshop/screen/show_shop_food_menu.dart';
import 'package:eatporkshop/utility/my_constant.dart';
import 'package:eatporkshop/utility/my_style.dart';
import 'package:flutter/material.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readShop();
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 180.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
          );
  }

  Future<Null> readShop() async {
    String url =
        "${MyConstant().domain}/eatporkshop/api/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop";
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      int index = 0;

      for (var item in result) {
        UserModel model = UserModel.fromJson(item);

        String nameShop = model.nameShop;
        if (nameShop.isNotEmpty) {
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopFoodMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}${userModel.urlPicture}'),
              ),
            ),
            MyStyle().mySizebox(),
            MyStyle().showTitleH3(userModel.nameShop),
          ],
        ),
      ),
    );
  }
}
