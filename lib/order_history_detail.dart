import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/order.dart';
import 'api/api.dart';

Order order =
    Order(0, 0, "", "", "", 0, 0, "", "", "", "", 0, "", 0, "", "", "", "");
Duration? duration;
bool connect = true;

class OrderHistoryDetailScreen extends StatefulWidget {
  const OrderHistoryDetailScreen(
      {Key? key, required this.orderId, required, required this.storeId})
      : super(key: key);
  final int orderId;
  final String storeId;
  @override
  State<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  @override
  void initState() {
    orderDetail();
    super.initState();
  }

  orderDetail() async {
    try {
      var response = await http.post(Uri.parse(API.orderDetail), body: {
        'orderId': widget.orderId.toString(),
        'storeId': widget.storeId
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("오더 디테일 불러오기 성공");
          print(responseBody['userData']);
          order = Order.fromJson(responseBody['userData']);
          DateTime orderTime = DateTime.parse(order!.orderTime);
          DateTime current = DateTime.now();

          duration = current.difference(orderTime);
          print("duration : $duration");
        } else {
          print("오더 디테일 불러오기 실패");
        }
      } else {
        print("오더 디테일 불러오기 실패2");
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String deliveryState = "";
    String payment = "";
    if (order?.state != 4) {
      deliveryState = "배달이 진행 중입니다.";
    } else {
      deliveryState = "배달이 완료되었습니다.";
    }
    if (order?.payment == 0) {
      payment = "선결제";
    } else if (order?.payment == 1) {
      payment = "카드결제";
    } else {
      payment = "현금결제";
    }

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
                title: Text("주문 내역",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    deliveryState,
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 15),
                  Text("주문일시 : ${order?.orderTime}"),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      "주문번호 : ${order?.orderId.hashCode.toRadixString(16).toUpperCase()}"),
                  SizedBox(height: 15),
                  Text(order!.storeName, style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Text(order!.orderInfo, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  Text(order!.storePhoneNum, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("요청 사항", style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Text(order!.deliveryRequest, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("결제 수단", style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Text(payment, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("결제 금액", style: TextStyle(fontSize: 22)),
                  SizedBox(height: 15),
                  Text(order!.orderValue.toString()+"원",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            )));
  }
}
