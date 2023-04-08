
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/constant/product/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/member_info.dart';
import 'package:shopping_ui/member/login/login.dart';
import 'package:shopping_ui/member/modify/modify_member_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/qna_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/main_qna.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/view_qna.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/member/mypage/manage_address/main_address.dart';
import 'package:shopping_ui/member/mypage/mypage.dart';
import 'package:shopping_ui/product/pages/actiongame/components/paid_info.dart';
import 'package:shopping_ui/product/pages/actiongame/order/order_result.dart';
import 'package:shopping_ui/product/pages/home_screen.dart';

class ShowAlertDialog {      

  AccessToDB accessToDB = AccessToDB();

  Future<void> showMyDialog({required BuildContext context, required String title, required String message, int? nSort, MemberInfo? mInfo, String? mId, String? qId}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // When false, user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),              
            ],
          ),
        ),
        actions: [
          returnButton(
            context: context,
            nSort: nSort,
            mInfo: mInfo,
            mId: mId,
            qId: qId,
          ),                  
        ],
      );
    },
  );
}

  Widget returnButton ({required BuildContext context, int? nSort, MemberInfo? mInfo, String? mId, String? qId}) {  
    if(nSort==installKakao||nSort==installNaver)
    {    
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: const Text('설치'),
            onPressed: () {
              if (nSort == installKakao) {LaunchReview.launch(androidAppId: "com.kakao.talk");}
              else if (nSort == installNaver) {LaunchReview.launch(androidAppId: "com.nhn.android.search");}
              Navigator.pop(context, 'pop');
            }
          ),
          SizedBox(width: 5,),
          ElevatedButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.pop(context, 'pop');              
            }
          ),
        ],
      );      
    } else {
      return ElevatedButton(
        child: const Text('확인'),
        onPressed: () {
          if(nSort==toLoginPage) {                   
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(
                builder: (_) => LoginPage(),                
              ),
              (route) => false,
            );              
          } else if (nSort == toMainPage) {
            
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(
                builder: (_) => RootApp(),
              ),
              (route) => false,
            );                
          } else if (nSort == toModifyPage) {                
            Navigator.pushReplacement(
              context, 
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => ModifyPage(mInfo: mInfo!),
                transitionDuration: const Duration(seconds: 0),
              ),
            );              
          } else if (nSort == toMyPage) {                
            Navigator.pushReplacement(
              context, 
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MypagePage(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );              
          } else if (nSort == toAddressMainPage) {
            accessToDB.getAdressList(mId: mId).then((value) {
              var json = jsonDecode(value);
              if(json['code']=='success') {
                getAddreddList(value).then((value) {                            
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressMainPage(addressList: value, mId: mId!)),
                  ModalRoute.withName('/AddressMain')                              
                  );
                });
              } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressMainPage(addressList: [], mId: mId!)),
                    ModalRoute.withName('/AddressMain')                              
                  );
                }
            });             
          } else if (nSort == toQnAMainPage) {    
            accessToDB.getQnAList(mId: mId).then((value) {
              var json = jsonDecode(value);
              if(json['code']=='success') {
                getQnAList(value).then((value) {  
                                                                                    
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: ((context) => QnAMainPage(mId: mId!))
                    ),
                    ModalRoute.withName('/QnAMain')
                  );
                });
              } else {                
                setQnAListNull().then((value) {
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(                                
                    builder: (context) => QnAMainPage(mId: mId!,)),
                  ModalRoute.withName('/QnAMain')                              
                );
                });
                
              }
            });             
          } else if (nSort == toModifiedQnAPage) {
            accessToDB.getModifiedQnA(qId: qId!).then((value) {
              var json = jsonDecode(value);
              if(json['code']=='success') {   

                accessToDB.getQnAList(mId: mId!)
                .then((value) {
                  getQnAList(value).then((value) {
                                                
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => QnAMainPage(mId: mId, ),),
                        ModalRoute.withName('/QnAMain')
                    );
                  });
                });
                

                // 수정된 화면으로
                // accessToDB.getQnAList(mId: mId!)
                // .then((value)=> getQnAList(value))
                // .then((value) => QnAMainPageState.qnaList=value)
                // .then((value) => getModifiedQnAInfo(json))
                // .then((value) {  
                //   Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ViewQnAPage(qInfo: value)),
                //   ModalRoute.withName('/QnAMain')
                //   );                  
                // });
              } else {
                print('failed')           ;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MypagePage(),
                      ),
                    ModalRoute.withName(MypagePage().toString())                            
                  );
                }
            });             
          } else if (nSort == toOrderResultPage) {            
            accessToDB.getPaidInfo(mId: mId).then(
              (value) {
                var json = jsonDecode(value);
                
                if(json['code']=='success'){
                  getPaidList(json).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                      builder: (context) => OrderResultPage(paidList: value, pInfo: dbPInfo1,)),
                  );
                  });                  
                }
              });     
          } else {
            Navigator.pop(context, 'OK');                      
          }              
        },
      );
    }
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

  Future<List<QnAInfo>> getQnAList(dynamic value) async {

    var json = jsonDecode(value);

    List<QnAInfo> qnaList = [];
    
    for(Map qna in json['QnAList']) {

      String qId = qna['qId'];
      String mId = qna['mId'];
      String qTitle = qna['qTitle'];
      String qContent = qna['qContent'];
      String qDate = qna['qDate'];
      String qGroup = qna['qGroup'];
      String qStep = qna['qStep'];
      String qIndent = qna['qIndent'];
      String qPhoto1 = qna['qPhoto1'];
      String qPhoto2 = qna['qPhoto2'];
      String qPhoto3 = qna['qPhoto3'];
      String qRead = qna['qRead'];

      
      QnAInfo qnaInfo = QnAInfo(qId: qId, mId: mId, qTitle: qTitle, qContent: qContent, qDate: qDate, qGroup: qGroup, qStep: qStep, qIndent: qIndent, qPhoto1: qPhoto1, qPhoto2: qPhoto2, qPhoto3: qPhoto3, qRead: qRead);

      qnaList.add(qnaInfo);
    }     
    QnAMainPageState.qnaList = qnaList;    
    return qnaList;
  }

  Future<void> setQnAListNull() async {
    QnAMainPageState.qnaList = await [];
  }

  Future<QnAInfo> getModifiedQnAInfo(dynamic json) async {

    dynamic modifiedQnA = json['modifiedQnA'];

    String qId = modifiedQnA['qId'];
    String mId = modifiedQnA['mId'];
    String qTitle = modifiedQnA['qTitle'];
    String qContent = modifiedQnA['qContent'];
    String qDate = modifiedQnA['qDate'];
    String qGroup = modifiedQnA['qGroup'];
    String qStep = modifiedQnA['qStep'];
    String qIndent = modifiedQnA['qIndent'];
    String qPhoto1 = modifiedQnA['qPhoto1'];
    String qPhoto2 = modifiedQnA['qPhoto2'];
    String qPhoto3 = modifiedQnA['qPhoto3'];
    String qRead = modifiedQnA['qRead'];

      
    QnAInfo qInfo = await QnAInfo(qId: qId, mId: mId, qTitle: qTitle, qContent: qContent, qDate: qDate, qGroup: qGroup, qStep: qStep, qIndent: qIndent, qPhoto1: qPhoto1, qPhoto2: qPhoto2, qPhoto3: qPhoto3, qRead: qRead);
    
    return qInfo;
  }

  Future<List<PaidInfo>> getPaidList(dynamic json) async {

    List<PaidInfo> paidList = [];
    
    for(Map tempInfo in json['paidList']) {
          
      String pId = tempInfo['pId'];
      String mId = tempInfo['mId'];
      String pcId = tempInfo['pcId'];
      String pAddress = tempInfo['pAddress'];
      String pDeliverymemo = tempInfo['pDeliverymemo'];
      String totalPrice = tempInfo['totalPrice'];
      String pCount = tempInfo['pCount'];
      String pDate = tempInfo['pDate'];
      
      PaidInfo paidInfo = PaidInfo(pId: pId, mId: mId, pcId: pcId, pCount: pCount, pAddress: pAddress, pDeliverymemo: pDeliverymemo, totalPrice: totalPrice, pDate: pDate);

      paidList.add(paidInfo);
    }     
    
    return paidList;
  }  

}


