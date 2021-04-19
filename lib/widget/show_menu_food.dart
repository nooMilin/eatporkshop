import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eatporkshop/model/food_model.dart';
import 'package:eatporkshop/model/user_model.dart';
import 'package:eatporkshop/utility/my_constant.dart';
import 'package:eatporkshop/utility/my_style.dart';
import 'package:flutter/material.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFood({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List();
  int amount = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${MyConstant().domain}/eatporkshop/api/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);

    var result = json.decode(response.data);

    for (var item in result) {
      FoodModel foodModel = FoodModel.fromJson(item);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                amount = 1;
                confirmOrder(index);
              },
              child: Row(
                children: <Widget>[
                  showFoodImage(context, index),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().mainTitle,
                            ),
                          ],
                        ),
                        Text(
                          '${foodModels[index].price} บาท',
                          style: TextStyle(
                              fontSize: 20,
                              color: MyStyle().darkColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 8.0,
                              child: Text(foodModels[index].detail),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${foodModels[index].pathImage}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                foodModels[index].nameFood,
                style: MyStyle().mainH2Title,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 180,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${foodModels[index].pathImage}'),
                      fit: BoxFit.cover),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 36,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                      });
                    },
                  ),
                  Text(
                    amount.toString(),
                    style: MyStyle().mainTitle,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        Navigator.pop(context);

                        addOrderToCart();
                      },
                      child: Text(
                        'สั่งซื้อ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addOrderToCart() {}
}
