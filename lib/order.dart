import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'api/api.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.storeName, required this.foods, required this.price, required this.storeId, required this.storeLocation}) : super(key: key);
  final String storeName;
  final String storeId;
  final String storeLocation;
  final String foods;
  final int price;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  List<String> list = ["선결제", "카드결제", "현금결제"];
  String? dropdownValue = "선결제";

  final TextEditingController _addrController = TextEditingController(); //입력되는 값을 제어
  final TextEditingController _requestController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  newOrder(double deliveryDistance, int deliveryFee, String deliveryLocation, String deliveryRequest, String storeId, int payment, String orderInfo, int orderValue, String customerNum) async {
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
            'orderValue' : orderValue.toString(),
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
    double latitude_destination = 37.58886;
    double longitude_destination = 26.3546;

    double latitude_origin = 37.58886;
    double longitude_origin = 26.3546;

    String REST_API_KEY ="eadc10ffba8f652a200505f28c3cf92d";

    return GestureDetector(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            backgroundColor: Color(0xff4B60F6),
            title: Text(
              widget.storeName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2,
          ),
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
                        widget.foods,
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
                        controller: _addrController,
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
                        controller: _requestController,
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
                        widget.price.toString() + '원',
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              TextButton(onPressed: () async {
                int paymentMethod;
                List<geo.Location> locations_destination = await geo.locationFromAddress( _addrController.text.trim());
                latitude_destination = locations_destination[0].latitude.toDouble();
                longitude_destination = locations_destination[0].longitude.toDouble();

                List<geo.Location> locations_origin = await geo.locationFromAddress(widget.storeLocation);
                latitude_origin = locations_origin[0].latitude.toDouble();
                longitude_origin = locations_origin[0].longitude.toDouble();

              final Distance distance = Distance();
              final double deliveryDistance = distance.as(LengthUnit.Kilometer, LatLng(latitude_origin,longitude_origin) , LatLng(latitude_destination, longitude_destination));

                if(dropdownValue == "카드결제") {
                  paymentMethod = 1;
                } else if(dropdownValue == "현금결제") {
                  paymentMethod = 2;
                } else {
                  paymentMethod = 0;
                }

                int deliveryFee = (deliveryDistance/0.5).toInt()* 1000;

                newOrder(deliveryDistance, deliveryFee, _addrController.text.trim(), _requestController.text.trim(), widget.storeId, paymentMethod, widget.foods, widget.price, '01011112222');
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



