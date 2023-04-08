import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/constant/product/constants.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/member/mypage/customer_service/paid_history/view_paid.dart';
import 'package:shopping_ui/product/bootpay/temp/detailscreen_temp.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/pages/category/new_list.dart';
import 'package:shopping_ui/product/pages/category/popular_list.dart';
import 'package:shopping_ui/product/pages/category/sale_list.dart';
import 'package:shopping_ui/product/pages/home_screen.dart';
import 'package:shopping_ui/product/pages/map.dart';
import 'package:shopping_ui/product/pages/search_page.dart';
import 'package:shopping_ui/widgets/custom_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<DetailInfo> switchList = [dbPInfo1, dbPInfo2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("최신 게임",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('보러가기', style: TextStyle(color: accent, fontWeight: FontWeight.bold),),
                  // SizedBox(
                  //   width: 0,
                  // ),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const NewGameList())),
                    icon: Icon(
                      FontAwesomeIcons.gamepad,
                      color: accent,
                      size: 20,
                    ),
                  ),  
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CustomeCarouselHomePage(
          items: slider,
        ),

        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("인기 게임",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('보러가기', style: TextStyle(color: accent, fontWeight: FontWeight.bold),),
                  // SizedBox(
                  //   width: 0,
                  // ),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const PopularGameList())),
                    icon: Icon(
                      FontAwesomeIcons.gamepad,
                      color: accent,
                      size: 20,
                    ),
                  ),  
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(recently.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(populargame[index]['imgUrl'] as String),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          populargame[index]['title'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              height: 1.5),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          "\￦ " + (populargame[index]['price'] as String),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: accent,
                              height: 1.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
        ),

        SizedBox(
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("특가 상품",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('보러가기', style: TextStyle(color: accent, fontWeight: FontWeight.bold),),
                  // SizedBox(
                  //   width: 0,
                  // ),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const SaleGameList())),
                    icon: Icon(
                      FontAwesomeIcons.gamepad,
                      color: accent,
                      size: 20,
                    ),
                  ),  
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(recently.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(salegame[index]['imgUrl'] as String),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          salegame[index]['title'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              height: 1.5),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\￦" + (salegame[index]['price'] as String),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accent,
                                  height: 1.5),
                            ),
                            Text(
                              " -> " + "￦" + (salegame[index]['sprice'] as String),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: redColor,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
        ),
        SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(switchList.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(                    
                    width: 350,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(switchList[index].imgurl),
                            fit: BoxFit.cover)),
                    child: TextButton(
                      child: Text(''),
                      onPressed: () {
                        // 결제 페이지로 이동
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            settings: RouteSettings(name: '/temp'),
                            builder: (context) => TempDetailScreen2(pInfo: switchList[index],))
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          switchList[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              height: 1.5),
                        ),                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                            
                            Text(
                              "￦" + (switchList[index].price),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: redColor,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: accent),
            child: Text('지점 찾기'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => gMapPage()));
            },
          ),
        ),
      ],
    );
  }
}