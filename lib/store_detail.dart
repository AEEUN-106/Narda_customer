import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:narda_customer/order_history_detail.dart';
import 'model/menu.dart';
import 'model/order.dart';
import 'api/api.dart';
import 'order.dart';

//List<Menu> menus = [];
List<Map<String, dynamic>> menus = [];

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({Key? key, required this.storeId, required this.storeName, required this.storeLocation}) : super(key: key);
  final String storeId;
  final String storeName;
  final String storeLocation;
  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  // Map<String, int> foods;

  @override
  void initState() {
    menuList();
    super.initState();
  }

  menuList() async {
    menus = [];
    try {
      var response = await http.post(Uri.parse(API.menuList), body: {
        'storeId' : widget.storeId
      });
      if (response.statusCode == 200) {
        //menus = [];
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("메뉴 리스트 불러오기 성공");

          List<dynamic> responseList = responseBody['userData'];
          for (int i = 0; i < responseList.length; i++) {
            Map<String, dynamic> tmp = {
              'idx' : responseList[i]['idx'],
              'menuName' : responseList[i]['menuName'],
              'menuPrice' : int.parse(responseList[i]['menuPrice']),
              'num' : 0,
            };
            menus.add(tmp);
          }
        }
        setState(() {});
      }
      else{
        print("메뉴 리스트 불러오기 실패");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    var _listView = ListView.separated(
      // padding: const EdgeInsets.all(3),
      itemCount: menus.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: Container(
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('asset/images/${menus[index]['idx']}.jpeg'),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            title: Text(menus[index]['menuName']),
            subtitle: Text('${menus[index]['menuPrice']}원'),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: (){
                    if(menus[index]['num'] > 0)menus[index]['num']--;
                    setState(() {});
                  }, child: Text("-", style: TextStyle(fontSize: 20),)),
                  Text(menus[index]['num'].toString(), style: TextStyle(fontSize: 15),),
                  TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: (){
                    menus[index]['num']++;
                    setState(() {});
                  }, child: Text("+")),
                ],
            ),

            // isThreeLine: true,
            onTap: () {

            },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );

    return GestureDetector(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              shape: Border(
                  bottom: BorderSide(
                    color: Color(0xfff1f2f3),
                    width: 2,
                  )),
              title: Text(widget.storeName,
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          body: Column(children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Expanded(child: _listView),
            FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xff475dfe)
                ),
                onPressed: (){
              String foodStr = "";
              num totalPrice = 0;

              menus.forEach((element) {
                if(element['num'] > 0){
                  foodStr += '${element['menuName']} ${element['num']}개, ';
                  totalPrice += element['num'] * element['menuPrice'];
                }
              });

              foodStr = foodStr.substring(0, foodStr.length-2);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OrderScreen(storeName: widget.storeName, storeId: widget.storeId, foods: foodStr, price: totalPrice as int, storeLocation: widget.storeLocation,)),
              );
            }, child: Text("주문하기", style: TextStyle(fontSize: 20),)),
            SizedBox(height: 10,)
          ]),
        )
    );
  }
}



