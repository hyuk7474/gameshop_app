import 'dart:convert';





import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/product/constants.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/product/components/detail.dart';

import 'package:shopping_ui/product/pages/actiongame/buy_page.dart';
import 'package:shopping_ui/product/pages/actiongame/order/order_process.dart';

class BuyModal extends StatefulWidget {
  //late DetailInfo? pInfo; this.pInfo,
  late DetailInfo? detailInfo;

  BuyModal({Key? key, this.detailInfo}) : super(key: key);

  @override
  State<BuyModal> createState() => _BuyModalState();
}

class _BuyModalState extends State<BuyModal> {
  // get title => widget.detailInfo.title;
  // get price => widget.detailInfo.price;
  // get story => widget.detailInfo.story;
  // get imgurl => widget.detailInfo.imgurl;
  // get imgurl1 => widget.detailInfo.imgurl1;
  // get imgurl2 => widget.detailInfo.imgurl2;
  // get imgurl3 => widget.detailInfo.imgurl3;
  // get imgurl4 => widget.detailInfo.imgurl4;
  // get imgurl5 => widget.detailInfo.imgurl5;
  // get ex => widget.detailInfo.ex;
  // get spec => widget.detailInfo.spec;

  late SharedPreferences prefs;
  
  late String title = widget.detailInfo!.title;
  late double price = double.parse(widget.detailInfo!.price);  
  late String imgurl =  widget.detailInfo!.imgurl;

  late String? _mId;  

  Future<void> getSharedPreferences_mId() async {
    prefs = await SharedPreferences.getInstance();    
    _mId = prefs.getString("mId") ?? 'ID를 불러오지 못 했습니다.';
    // _mId = prefs.getString("mId") ?? 'nope';    
  }

  @override
  void initState() {    
    super.initState();    
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

  

  @override
  Widget build(BuildContext context) {
    return Visibility(
      
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(0)),
                Text('구매 수량', style: TextStyle(fontSize: 20),)
              ],
            ),
            SizedBox(height: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.minusCircle, color: accent,),
                    onPressed: () {
                      _decrementCounter();
                    },
                  ),
                ),
                Text("${returnCounter(counter)}", style: TextStyle(fontSize: 25),),
                SizedBox(
                  height: 50,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.plusCircle, color: accent,),
                    onPressed: () {
                      _incrementCounter();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 0,),
            Divider(
              thickness: 2,
              color: accent,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: accent),
                  onPressed: () {
                        
                    AccessToDB accessToDB = AccessToDB();                    
                    getSharedPreferences_mId().then((value) {                      
                      accessToDB.getAdressList(mId: _mId)
                      .then((value) {
                        var json = jsonDecode(value);
                        print(json);
                        if(json['code']=='success') {
                          getAddreddList(value).then((value) {                            
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderProcess(addressList: value, mId: _mId, pInfo: widget.detailInfo!, qty: counter,)),
                            );
                          });
                        } else {                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderProcess(addressList: [], mId: _mId, pInfo: widget.detailInfo!, qty: counter,)),                              
                            );
                        }                 
                      });
                    });                  
                  },
                  child: Text('구매하러 가기'),
                ),                
              ],
            ),
          ],
        ),
      ),
    );
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