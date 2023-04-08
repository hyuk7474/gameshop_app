import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/member/mypage/manage_address/modify_address.dart';
import 'package:shopping_ui/product/pages/actiongame/order/order_process.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';

class CardList extends StatefulWidget {  
  late List<AddressInfo> addressList;
  late String mId;
  
  CardList({
    Key? key,
    required this.addressList,
    required this.mId,
    }) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(      
      child: Container(
              width:  double.infinity,
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,                
                itemCount: widget.addressList.length,
                itemBuilder: (BuildContext context, int index){
                  return PersonTile(widget.addressList[index], index, widget.mId);
                }
              ),
            ),
    );
  }
}

class PersonTile extends StatelessWidget{
  final AddressInfo aInfo;
  final int index;
  final String _mId;
  
  PersonTile(this.aInfo, this.index, this._mId);

  AccessToDB accessToDB = AccessToDB();
  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  
  String getAMain() {
    String aMain = aInfo.aMain.substring(aInfo.aMain.indexOf(' ', aInfo.aMain.indexOf(' ')+1));
    print('--------aMain---------');
    print(aMain);
    if(aMain.length > 13){
      aMain = '${aMain.substring(0,12)}...';
    }
    
    return aMain;
  }
  

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.amber[100],
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(                                                  
                child: Column(                              
                  children: [                    
                    Text(
                      "${aInfo.aName}\n${aInfo.aMain}\n${aInfo.aSub ?? ""}(${aInfo.aZipcode})"),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(                                        
                    child: ElevatedButton(
                      child: Text('선택'),
                      onPressed: () {                                                
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),         
    );   
  }

  

  void _onClick(int index) {
    print('$index 클릭됨');

  }
}