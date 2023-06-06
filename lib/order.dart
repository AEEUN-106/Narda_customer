import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api/api.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen(
      {Key? key,
      required this.storeName,
      required this.foods,
      required this.price,
      required this.storeId, required String storeLocation})
      : super(key: key);
  final String storeName;
  final String storeId;
  final String foods;
  final int price;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<String> list = ["선결제", "카드결제", "현금결제"];
  String? dropdownValue = "선결제";

  final TextEditingController _addrController =
      TextEditingController(); //입력되는 값을 제어
  final TextEditingController _requestController = TextEditingController();
  final TextEditingController _addrDetailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  newOrder(
      double deliveryDistance,
      int deliveryFee,
      String deliveryLocation,
      String deliveryLocationDetail,
      String deliveryRequest,
      String storeId,
      int payment,
      String orderInfo,
      int orderValue,
      String customerNum) async {
    try {
      print("post 실행");
      var response =
          await http.post(Uri.parse(API.newOrder), body: <String, String>{
        'deliveryDistance': deliveryDistance.toString(),
        'deliveryFee': deliveryFee.toString(),
        'deliveryLocation': deliveryLocation,
            'deliveryLocationDetail' : deliveryLocationDetail,
        'deliveryRequest': deliveryRequest,
        'storeId': storeId.toString(),
        'payment': payment.toString(),
        'orderInfo': orderInfo,
        'orderValue': orderValue.toString(),
        'customerNum': customerNum
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("새로운 오더 생성 성공");
        } else {
          print("새로운 오더 생성 실패2");
        }
      } else {
        print("새로운 오더 생성 실패3");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(child:Container(
          margin: EdgeInsets.all(20),
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '주문 내역',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 15),
                      Text(
                        widget.foods,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Text('배달 주소', style: TextStyle(fontSize: 22)),
                      TextFormField(
                        controller: _addrController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: '[배달 주소를 적어주세요]',
                        ),
                      ),
                      TextFormField(
                        controller: _addrDetailController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: '[배달 상세 주소를 적어주세요]',
                        ),
                      ),
                      SizedBox(height: 15),
                      Text('010-1111-2222', style: TextStyle(fontSize: 18),),
                      SizedBox(height: 20),
                      Text('요청 사항', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        controller: _requestController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: '[요청 사항을 적어주세요.]',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('결제 수단', style: TextStyle(fontSize: 22)),
                      DropdownButton(
                        value: dropdownValue,
                        items: list.map(
                              (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: 18),),
                            );
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          dropdownValue = value!;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20),

                      Text('결제 금액', style: TextStyle(fontSize: 22)),
                      SizedBox(height: 15),
                      Text(
                        widget.price.toString() + '원', style: TextStyle(fontSize: 18),
                      ),

                    ],
                  ),
                  SizedBox(height: 100,),

                  FilledButton(onPressed: (){
                    int paymentMethod;
                    if (dropdownValue == "카드결제") {
                      paymentMethod = 1;
                    } else if (dropdownValue == "현금결제") {
                      paymentMethod = 2;
                    } else {
                      paymentMethod = 0;
                    }
                    newOrder(
                        3.4,
                        3000,
                        _addrController.text.trim(),
                        _addrDetailController.text.trim(),
                        _requestController.text.trim(),
                        widget.storeId,
                        paymentMethod,
                        widget.foods,
                        widget.price,
                        '01011112222');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, child: Text("주문하기", style: TextStyle(fontSize: 20),)),
                ],
              )
          ),)
        ),
    );
  }
}
