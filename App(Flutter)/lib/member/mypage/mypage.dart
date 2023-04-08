import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/member_info.dart';
import 'package:shopping_ui/member/modify/modify_pw.dart';

import 'package:shopping_ui/member/modify/pw_check.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/qna_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/paid_history/main_paid.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/main_qna.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/member/mypage/manage_address/main_address.dart';
import 'package:shopping_ui/product/bootpay/temp/detailscreen_temp.dart';
import 'package:shopping_ui/product/pages/home_screen.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';

class MypagePage extends StatefulWidget {
  const MypagePage({Key? key}) : super(key: key);

  @override
  State<MypagePage> createState() => _MypagePageState();
}

class _MypagePageState extends State<MypagePage> {

  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  late MemberInfo mInfo;

  late SharedPreferences prefs;

  late String mId, mName, mPnum, mEmail;
  late int mBlack, status;

  void checkLogin() {
    if(status==0) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) => RootApp())));
    }
  }

  @override
    void initState() {
      
      getSharedPreferences().then((value) => checkLogin());
      super.initState();
    }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    
    status = (prefs.getInt('status') ?? 0);
    mId = (prefs.getString("mId") ?? '');      
    mName = (prefs.getString("mName") ?? '');
    mPnum = (prefs.getString("mPnum") ?? ''); 
    mEmail = (prefs.getString("mEmail") ?? '');
    mBlack = (prefs.getInt("mBlack") ?? 0);
    
    mInfo = await MemberInfo(mId: mId, mName: mName, mPnum: mPnum, mEmail: mEmail, mBlack: mBlack, status: status);
  }

  @override
  void dispose() {
    print("disposed!!");
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SingleChildScrollView(
        child: 
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                  
                  
                  Text('회원 정보🧙‍♂️', style: TextStyle(fontSize: subTitleTextSize),),
                  SizedBox(height: defaultPadding,),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PWCheckPage(mInfo: mInfo,)),
                              ); 
                          },
                        child: Text('내 정보 수정 🔒'),
                        ),
                      ),
                      SizedBox(width: defaultPadding,),
                      Expanded(child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => ModifyPW(mInfo: mInfo)
                            )
                          );
                        }, 
                        child: Text('비밀번호 변경🔑')
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: myMenuPadding,),
                  Row(
                    children: [                                          
                      Expanded(child: ElevatedButton(onPressed: (){}, child: Text('찜 목록 📜'))),
                      SizedBox(width: 10,),
                      Expanded(child: ElevatedButton(onPressed: (){}, child: Text('나의 리뷰 📑'))),
                    ],
                  ),
                  SizedBox(height: defaultPadding,),
                  Text('주문 정보📦', style: TextStyle(fontSize: subTitleTextSize),),
                  SizedBox(height: defaultPadding,),
                  Row(
                    children: [                       
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                        child: Text('장바구니🛒'),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(                            
                                builder: (context) => MainPaidPage(),
                                settings: RouteSettings(name: '/PaidHistoryMain'),
                              )
                            );                                         
                          }, 
                          child: Text('주문 내역 조회🧾')
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: myMenuPadding,),
                  Row(
                    children: [                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            AccessToDB accessToDB = AccessToDB();
                            accessToDB.getAdressList(mId: mId).then((value) {
                              var json = jsonDecode(value);
                              if(json['code']=='success') {
                                getAddreddList(value).then((value) {                            
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: RouteSettings(name: '/AddressMain'),
                                    builder: (context) => AddressMainPage(addressList: value, mId: mId,)),                              
                                  );
                                });
                              } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      settings: RouteSettings(name: '/AddressMain'),
                                      builder: (context) => AddressMainPage(addressList: [], mId: mId)),                              
                                  );
                              }
                            });                        
                          }, 
                          child: Text('배송지 관리🏡')),
                      ),
                      SizedBox(width: defaultPadding,),
                      Expanded(child: SizedBox())
                    ],
                  ),
                  SizedBox(height: defaultPadding,),
                  Text('고객 센터👩‍🚀', style: TextStyle(fontSize: subTitleTextSize),),
                  SizedBox(height: defaultPadding,),
                  Row(
                    children: [
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('공지사항📢'),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            AccessToDB accessToDB = AccessToDB();
                            accessToDB.getQnAList(mId: mId).then((value) {
                              var json = jsonDecode(value);
                              if(json['code']=='success') {
                                getQnAList(value).then((value) {
                                  QnAMainPageState.qnaList = value;
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => QnAMainPage(mId: mId, ),
                                      settings: RouteSettings(name: '/QnAMain')
                                    )
                                  );
                                });
                              } else {        
                                QnAMainPageState.qnaList = [];                            

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: RouteSettings(name: '/QnAMain'),
                                    builder: (context) => QnAMainPage(mId: mId)),                              
                                    
                                );
                              }
                            });                        
                          }, 
                          child: Text('문의사항📮')),
                      ),
                    ],
                  ),
                  SizedBox(height: defaultPadding,),
                  Container(
                    width: 300,
                    height: 50,
                    alignment: Alignment.centerRight,                    
                    child: ElevatedButton(
                      onPressed: () {
                        snsLogout();
                        prefs.clear();
                        Navigator.pop(context);
                        showAlertDialog
                          .showMyDialog(context: context, 
                                        title: "로그아웃 완료😀", 
                                        message: '이용해주셔서 고맙습니다.',
                                        nSort: toMainPage,
                                        );
                      }, 
                      child: Text('로그아웃'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),                      
                      ),
                  ),                  
                ],
              ),
            ),            
          
      ),
    );
  }

  void snsLogout() async {
    if(mId.indexOf('(gg)')>0){
      FirebaseAuth.instance.signOut();
    } else if(mId.indexOf('(fb))')>0){
      await FacebookAuth.instance.logOut();
    } else if(mId.indexOf('(n)')>0){
      await FlutterNaverLogin.logOutAndDeleteToken();
    } else if(mId.indexOf('(k)')>0){
      try {
        await UserApi.instance.logout();
        print('로그아웃 성공, SDK에서 토큰 삭제');
      } catch (error) {
        print('로그아웃 실패, SDK에서 토큰 삭제 $error');
      }
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
    
    return qnaList;
  }
}