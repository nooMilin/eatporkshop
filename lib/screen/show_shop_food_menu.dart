import 'package:eatporkshop/model/user_model.dart';
import 'package:eatporkshop/utility/my_style.dart';
import 'package:eatporkshop/widget/about_shop.dart';
import 'package:eatporkshop/widget/show_menu_food.dart';
import 'package:flutter/material.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopFoodMenu({Key key, this.userModel}) : super(key: key);

  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel userModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(
      AboutShop(
        userModel: userModel,
      ),
    );
    listWidgets.add(ShowMenuFood(
      userModel: userModel,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.nameShop),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBar(),
    );
  }

  BottomNavigationBar showBottonNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuFoodNav(),
        ],
      );

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      title: Text('รายละเอียดร้าน'),
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      title: Text('เมนูอาหาร'),
    );
  }
}
