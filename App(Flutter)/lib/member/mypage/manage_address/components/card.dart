import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/member/mypage/manage_address/modify_address.dart';
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
    return Container(      
      child: Container(
              width:  double.infinity,
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
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
      child: InkWell(
        splashColor:  Colors.blue,
        onTap: () => _onClick(index),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                                
                  Text(aInfo.aName),                  
                  Text(getAMain()),
                  TextButton(                    
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_)=>ModifyAddressPage(aInfo: aInfo)), 
                        );
                    }, 
                    child: Text('수정')
                  ),
                  TextButton(                    
                    onPressed: () {
                      accessToDB.deleteAdress(mId: _mId, aName: aInfo.aName)
                      .then((value) {
                        var json = jsonDecode(value);
                        if( json['code']=='success'){                          
                          showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "삭제 완료🐱‍🐉", 
                                          message: json['desc'],                                              
                                          nSort: toAddressMainPage,
                                          mId: _mId,
                                          );
                        } else {
                          showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "삭제 실패😣", 
                                          message: json['desc'],                                          
                                          );
                        }
                      });
                    }, 
                    child: Text('삭제')
                  ),
                ],
              ),              
            ],
          ),
        ),
      )             
    );   
  }

  

  void _onClick(int index) {
    print('$index 클릭됨');

  }
}