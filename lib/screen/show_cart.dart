import 'package:eatporkshop/model/cart_model.dart';
import 'package:eatporkshop/utility/my_style.dart';
import 'package:eatporkshop/utility/sqlite_helper.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    total = 0;
    for (var model in object) {
      String sumString = model.sum;
      int sumInt = int.parse(sumString);
      setState(() {
        cartModels = object;
        total = total + sumInt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: cartModels.length == 0 ? MyStyle().showProgress() : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNameShop(),
            buildHeadTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
          ],
        ),
      ),
    );
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyStyle().showTitleH3('Total = '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3Red(total.toString()),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('ร้าน ${cartModels[0].nameShop}'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle().showTitleH3('ระยะทาง = ${cartModels[0].distance} กม.'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle()
                  .showTitleH3('ค่าขนส่ง = ${cartModels[0].transport} บาท'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('ผลรวม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().mySizebox(),
          )
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].sum),
            ),
            Expanded(
                child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () async {
                int id = cartModels[index].id;
                await SQLiteHelper().deleteDataWhereId(id).then((value) {
                  print('Success Delete id = $id');
                  readSQLite();
                });
              },
            ))
          ],
        ),
      );
}
