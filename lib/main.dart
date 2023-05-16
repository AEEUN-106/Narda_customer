import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narda_customer/model/store.dart';
import 'package:narda_customer/order_history.dart';
import 'api/api.dart';
import 'store_detail.dart';


List<Store> stores = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NARDA_CUSTOMER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    storeList();
    super.initState();
  }

  storeList() async {
    try {
      var response = await http.post(Uri.parse(API.storeList), body: {});
      if (response.statusCode == 200) {
        stores = [];
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("가게 리스트 불러오기 성공");

          List<dynamic> responseList = responseBody['userData'];
          for (int i = 0; i < responseList.length; i++) {
            print(Store.fromJson(responseList[i]));
            stores.add(Store.fromJson(responseList[i]));
          }
        } else {
          print("가게 리스트 불러오기 실패");
        }
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff4B60F6),

              automaticallyImplyLeading: false,
              title: const Text(
                'NARDA',
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          OrderHistoryScreen(customerNum: '01011112222')),
                    );
                  },)
              ],
              elevation: 1.0,
            ),
          ),

        body: GridView.builder(
          itemCount: stores!.length, //item 개수
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
            childAspectRatio: 4 / 5, //item 의 가로 1, 세로 2 의 비율
            mainAxisSpacing: 10, //수평 Padding
            crossAxisSpacing: 10, //수직 Padding
          ),
          itemBuilder: (BuildContext context, int index) {
            //item 의 반목문 항목 형성
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        StoreDetailScreen(storeId: stores[index].storeId,
                          storeName: stores[index].storeName,storeLocation: stores[index].storeLocation,)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 100,
                  height: 100,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage('asset/images/${stores[index].storeId}.jpeg'),
                              fit: BoxFit.fill,
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(stores[index].storeName),
                      // Image.asset(
                      //   stores![index].storeName,
                      // ),
                    ],
                  ),
                ));
          },
        )));
  }
}
