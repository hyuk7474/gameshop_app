import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/mypage/manage_address/add_address.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/card.dart';
import 'package:shopping_ui/product/pages/actiongame/components/order_components.dart';

class AddressMainPage extends StatefulWidget {
  late List<AddressInfo>? addressList;
  late String mId;
  AddressMainPage({Key? key, this.addressList, required this.mId}) : super(key: key);

  @override
  State<AddressMainPage> createState() => _AddressMainPageState();
}

class _AddressMainPageState extends State<AddressMainPage> {

  GetAppBar getAppBar = GetAppBar();

  late String _mId = widget.mId;

  late SharedPreferences prefs;

  late List<AddressInfo>? addressList = widget.addressList;
  
  @override
  void initState() {      
    super.initState();
  }

  Widget checkList() {
    if(addressList!.isNotEmpty) {
      return CardList(addressList: addressList!, mId: _mId,);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            LineToSeperate(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("등록된 배송지가 없습니다."),
            ),
            LineToSeperate(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: orderAppbar),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: defaultPadding*3,),
          Text("배송지 목록🚚", style: TextStyle(fontSize: 24),),
          SizedBox(height: defaultPadding,),
          checkList(),
          TextButton(
            child: Text('배송지 추가'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddAddressPage()))
              );
            },
          ),
        ],
      ),
    );    
  }
}