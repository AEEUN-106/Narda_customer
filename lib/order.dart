import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api/api.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.storeName, required this.foods, required this.price, required this.storeId}) : super(key: key);
  final String storeName;
  final String storeId;
  final List<Map<String, dynamic>> foods;
  final int price;
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  List<String> list = ["선결제", "카드결제", "현금결제"];
  String? dropdownValue = "선결제";
  String foodStr = "";

  @override
  void initState() {
    // TODO: implement initState
    widget.foods.forEach((element) {
      if(element["주문량"] > 0) {
        foodStr += '${element["음식이름"]} ${element["주문량"]}개, ';
      }}
    );
    foodStr = foodStr.substring(0, foodStr.length-2);

    super.initState();
  }

  newOrder(double deliveryDistance, int deliveryFee, String deliveryLocation, String deliveryRequest, String storeId, int payment, String orderInfo, String customerNum) async {
    try {
      print("post 실행");
      var response = await http.post(
          Uri.parse(API.newOrder),
          body: <String, String> {
            'deliveryDistance' : deliveryDistance.toString(),
            'deliveryFee' : deliveryFee.toString(),
            'deliveryLocation' : deliveryLocation,
            'deliveryRequest' : deliveryRequest,
            'storeId' : storeId.toString(),
            'payment' : payment.toString(),
            'orderInfo' : orderInfo,
            'customerNum' : customerNum
          });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("새로운 오더 생성 성공");
        } else {
          print("새로운 오더 생성 실패2");
        }
      }
      else {
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.storeName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child:  Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '주문내역', style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      Text(
                        foodStr,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),

                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '배달지', style: TextStyle(fontSize: 20)
                      ),
                      TextFormField(
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: '[배달 주소를 적어주세요.]',
                          ),
                      ),
                      SizedBox(height: 10),
                      Text('010-1111-2222'),
                      SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('요청사항', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        // controller: _model.textController2,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: '요청 사항을 적어주세요.',
                        ),
                      ),
                      SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),

                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('결제수단', style: TextStyle(fontSize: 20)),
                        DropdownButton(
                          value: dropdownValue,
                          items: list.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          onChanged: (String? value) {
                            dropdownValue = value!;

                            if(dropdownValue == "선결제"){

                            }
                            else if(dropdownValue == "카드결제"){

                            }
                            else{

                            }
                            setState(() {});
                          },
                        ),
                      ]
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '결제금액', style: TextStyle(fontSize: 20)
                      ),
                      SizedBox(height: 15),
                      Text(
                        widget.price.toString(),

                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              TextButton(onPressed: (){
                int paymentMethod;
                if(dropdownValue == "카드결제") {
                  paymentMethod = 1;
                } else if(dropdownValue == "현금결제") {
                  paymentMethod = 2;
                } else {
                  paymentMethod = 0;
                }
                newOrder(3.4, 3000, '대구 북구 경진로31 101동 301호', '없음', widget.storeId, paymentMethod, foodStr, '01011112222');
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: Text("주문하기")),
            ],
          ),
        ),
      ),
    );
  }
}



