import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eatporkshop/model/order_model.dart';
import 'package:eatporkshop/utility/my_constant.dart';
import 'package:eatporkshop/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowStatusFoodOrder extends StatefulWidget {
  @override
  _ShowStatusFoodOrderState createState() => _ShowStatusFoodOrderState();
}

class _ShowStatusFoodOrderState extends State<ShowStatusFoodOrder> {
  String idUser;
  bool statusOrder = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMunuFoods = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildNonOrder() : buildContent();
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            buildNameShop(index),
            buildDateTimeOrder(index),
            buildDistance(index),
            buildTransport(index),
            buildHead(),
            buildListViewMenuFood(index),
          ],
        ),
      );

  ListView buildListViewMenuFood(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMunuFoods.length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMunuFoods[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listPrices[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listAmounts[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listSums[index][index2]),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3White('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3White('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3White('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3White('ผมรวม'),
          ),
        ],
      ),
    );
  }

  Row buildTransport(int index) {
    return Row(
      children: [
        MyStyle()
            .showTitleH3Purple('ค่าขนส่ง ${orderModels[index].transport} บาท'),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        MyStyle().showTitleH3Red('ระยะทาง ${orderModels[index].distance} กม.'),
      ],
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: [
        MyStyle()
            .showTitleH3('วัน เวลาที่ซื้อ ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        MyStyle().showTitleH2('ร้าน ${orderModels[index].nameShop}'),
      ],
    );
  }

  Center buildNonOrder() => Center(child: Text('ยังไม่มี ข้อมูล การสั่งอาหาร'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/eatporkshop/api/getOrderWhereIdUser.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          List<String> menuFoods = changeArray(model.nameFood);
          List<String> prices = changeArray(model.price);
          List<String> amounts = changeArray(model.amount);
          List<String> sums = changeArray(model.sum);
          setState(() {
            statusOrder = false;
            orderModels.add(model);
            listMunuFoods.add(menuFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
          });
        }
      }
    }
  }

  List<String> changeArray(String string) {
    List<String> list = List();
    String myString = string.substring(1, string.length - 1);
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();

      index++;
    }
    return list;
  }
}
