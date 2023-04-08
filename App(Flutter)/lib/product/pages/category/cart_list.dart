


import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/product/pages/actiongame/order/order_process.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/components/detail2.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen2.dart';
import 'package:shopping_ui/product/pages/search_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/widgets/modal/buymodal.dart';

class CartList extends StatefulWidget {
  late DetailInfo? detailInfo;

 CartList({Key? key, this.detailInfo}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {

  late SharedPreferences prefs;
  late String title = widget.detailInfo!.title;
  late double price = double.parse(widget.detailInfo!.price);  
  late String imgurl =  widget.detailInfo!.imgurl;
  late String? _mId;

  // get title => widget.detailInfo?.title;
  // get price => widget.detailInfo?.price;
  // get story => widget.detailInfo?.story;
  // get imgurl => widget.detailInfo?.imgurl;
  // get imgurl1 => widget.detailInfo?.imgurl1;
  // get imgurl2 => widget.detailInfo?.imgurl2;
  // get imgurl3 => widget.detailInfo?.imgurl3;
  // get ex => widget.detailInfo?.ex;
  // get spec => widget.detailInfo?.spec;

  final String colName = "cart";
  final String fnTitle = "gTitle";
  final String fnPrice = "gPrice";
  final String fnImg = "imgurl";

  final String fnEx = "gEx";
  final String fnSpec = "gSpec";
  final String fnStory = "gStory";
  final String fnImg1 = "imgurl1";
  final String fnImg2 = "imgurl2";
  final String fnImg3 = "imgurl3";

  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undPriceCon = TextEditingController();
  TextEditingController _undImgCon = TextEditingController();
  TextEditingController _undImg1Con = TextEditingController();
  TextEditingController _undImg2Con = TextEditingController();
  TextEditingController _undImg3Con = TextEditingController();
  TextEditingController _undStoryCon = TextEditingController();
  TextEditingController _undExCon = TextEditingController();
  TextEditingController _undSpecCon = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late CollectionReference cart;

  Future<void> getSharedPreferences_mId() async {
    prefs = await SharedPreferences.getInstance();    
    _mId = prefs.getString("mId") ?? '1452596181926921(fb)';
    // _mId = prefs.getString("mId") ?? 'nope';    
  }
  
  @override
  void initState() {
    super.initState();
    cart = FirebaseFirestore.instance.collection('cart');
  }

  int counter = 1;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }
  
  void _decrementCounter() {
    setState(() {
      counter--;
    });
  }

  int returnCounter(int num) {    
    int result = num;
    if(num < 1) {      
      setState(() {        
        counter = 1;
      });         
      result = 1;   
    }
    return result;
  }
  //_ActionGameListState(this.documentId);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "My WishList",
          style: TextStyle(color: accent),
        ),
        // actions: <Widget> [
        //       IconButton(
        //           onPressed: () => Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (_) => const Search2Page())),
        //           icon: Icon(Icons.search), color: accent,),
        //     ],
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("cart").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)Center(
            child: CircularProgressIndicator(),
          );
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              if(snapshot.data!.docs.isEmpty) {
                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Your cart is empty')
                    ],
                  ),
                );
              }
              else {
               return ListTile(
                  title: Text(
                    data['gTitle'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Row(
                    children: [
                //       SizedBox(
                //   height: 30,
                //   child: IconButton(
                //     icon: Icon(FontAwesomeIcons.minusCircle, color: accent,),
                //     onPressed: () {
                //       _decrementCounter();
                //     },
                //   ),
                // ),
                // Text("${returnCounter(counter)}", style: TextStyle(fontSize: 25),),
                // SizedBox(
                //   height: 30,
                //   child: IconButton(
                //     icon: Icon(FontAwesomeIcons.plusCircle, color: accent,),
                //     onPressed: () {
                //       _incrementCounter();
                //     },
                //   ),
                // ),
                      Text(
                        data['gPrice'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                                
                  leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data['imgurl']),
                    ), 
                  ),
                  trailing: SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                         _deleteProduct(snapshot.data!.docs[index].id);
                      }
                    ),
                  ),
                  
                  onTap: () {
                        DetailInfo2 detailInfo2 = DetailInfo2(
                          title: snapshot.data!.docs[index]['gTitle'],
                          price: snapshot.data!.docs[index]['gPrice'],
                          story: snapshot.data!.docs[index]['gStory'],
                          ex: snapshot.data!.docs[index]['gEx'],
                          spec: snapshot.data!.docs[index]['gSpec'], 
                          imgurl: snapshot.data!.docs[index]['imgurl'],
                          imgurl1: snapshot.data!.docs[index]['imgurl1'],
                          imgurl2: snapshot.data!.docs[index]['imgurl2'],
                          imgurl3: snapshot.data!.docs[index]['imgurl3'],
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen2(detailInfo2: detailInfo2)));
                      },
                  // onLongPress: () {
                  //   showDeleteDocDialog(document);
                  // },        
                ); 
              }
              return Container();
            }
          );
        }
      ),
      // bottomNavigationBar: 
      //   Container(
      //     height: 50,
      //     decoration: BoxDecoration(
      //       color: bar,
      //       border: Border(top: BorderSide(color: Color.fromARGB(255, 95, 208, 236).withOpacity(0.5))),  
      //     ),

      //     padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         ElevatedButton(
      //           child: Text('구매하러 가기'),
      //           style: ElevatedButton.styleFrom(primary: accent),
      //           onPressed: () {
      //             AccessToDB accessToDB = AccessToDB();                    
      //               getSharedPreferences_mId().then((value) {                      
      //                 accessToDB.getAdressList(mId: _mId)
      //                 .then((value) {
      //                   var json = jsonDecode(value);
      //                   print(json);
      //                   if(json['code']=='success') {
      //                     getAddreddList(value).then((value) {                            
      //                       Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => OrderProcess(addressList: value, mId: _mId, pInfo: widget.detailInfo!, qty: counter,)),
      //                       );
      //                     });
      //                   } else {                          
      //                     Navigator.pushReplacement(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => OrderProcess(addressList: [], mId: _mId, pInfo: widget.detailInfo!, qty: counter,)),                              
      //                       );
      //                   }                 
      //                 });
      //               });
      //           },
      //         )
      //       ],
      //     ),
      //   ),
    );
  }

  void _deleteProduct(String id) {
   FirebaseFirestore.instance.collection('cart').doc(id).delete();
  }

  Future<List<AddressInfo>> getAddreddList(dynamic value) async {

    var json = jsonDecode(value);

    List<AddressInfo> addressList = [];
    
    for(Map address in json['addressList']) {
          
      String aName = address['aName'];
      String aZipcode = address['aZipcode'];
      String aMain = address['aMain'];
      String aSub = address['aSub'];
      String aPrimary = address['aPrimary'];
      
      AddressInfo addressInfo = AddressInfo(aName: aName, aZipcode: aZipcode, aMain: aMain, aSub: aSub, aPrimary: aPrimary);

      addressList.add(addressInfo);
    }     
    
    return addressList;
  }
}