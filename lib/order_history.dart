import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:narda_customer/order_history_detail.dart';
import 'model/order.dart';
import 'api/api.dart';

List<Order> orders = [];

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key, required this.customerNum}) : super(key: key);
  final String customerNum;
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  @override
  void initState() {
    orderList();
    super.initState();
  }

  orderList() async{
    try{
      var response = await http.post(
          Uri.parse(API.orderHistory),
          body:{
            'customerNum' : widget.customerNum,
          }
      );
      if(response.statusCode == 200){
        orders = [];
        var responseBody = jsonDecode(response.body);
        if(responseBody['success'] == true){
          print("오더 리스트 불러오기 성공");

          List<dynamic> responseList = responseBody['userData'];
          for(int i=0; i<responseList.length; i++){
            print(Order.fromJson(responseList[i]));
            orders.add(Order.fromJson(responseList[i]));
          }
        }
        else {
          print("오더 리스트 불러오기 실패");
        }
        setState(() {});
        return orders;
      }
    }catch(e){print(e.toString());}
  }

  @override
  Widget build(BuildContext context) {

    var _listView = ListView.separated(
      // padding: const EdgeInsets.all(3),
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: Container(
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('asset/images/${orders[index].storeId}.jpeg'),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            title: Text(
                orders[index].storeName),
            subtitle: Text(orders[index].orderValue.toString() + '원'),
            trailing: orders[index].state!=4?Text("배달 중", style: TextStyle(color: Colors.red),):Text("배달 완료"),
            // isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  OrderHistoryDetailScreen(orderId: orders[index].orderId, storeId: orders[index].storeId)),
              );
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
              title: Text('주문 내역',
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
          ]),
        )
    );
  }
}



