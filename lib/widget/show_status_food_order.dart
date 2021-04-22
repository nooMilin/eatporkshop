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
            Text(orderModels[index].nameFood),
          ],
        ),
      );

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
      print('response ==>> $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          setState(() {
            statusOrder = false;
            orderModels.add(model);
          });
        }
      }
    }
  }
}
