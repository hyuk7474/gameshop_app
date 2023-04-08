import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/components/member_info.dart';
import 'package:shopping_ui/member/login/login.dart';

import 'package:shopping_ui/widgets/alert_dialog.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shopping_ui/constant/member/constants.dart';

class ModifyPage extends StatefulWidget {
  late MemberInfo mInfo;
  ModifyPage({Key? key, required this.mInfo}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {

  GetAppBar getAppBar = GetAppBar();

  late SharedPreferences prefs;

  ShowAlertDialog showAlertDialog = ShowAlertDialog();
  AccessToDB accessToDB = AccessToDB();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _mId, _mName, _mEmail, _mPnum;    
  
  String _chosenValue = '010';

  TextEditingController startPNumCtrl = TextEditingController();
  TextEditingController middlePNumCtrl = TextEditingController();
  TextEditingController endPNumCtrl = TextEditingController();
  // TextEditingController phonenumCtrl  = TextEditingController();

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();    
  }

  @override
  void initState() {    
    setInfo();
    getSharedPreferences();
    super.initState();
  }

  void setInfo() {
    _mId=widget.mInfo.mId;
    if(widget.mInfo.mPnum!=''){
      _chosenValue = widget.mInfo.mPnum.substring(0, widget.mInfo.mPnum.indexOf('-'));
      middlePNumCtrl.text = widget.mInfo.mPnum.substring(_chosenValue.length+1, widget.mInfo.mPnum.indexOf('-',_chosenValue.length+1));
      endPNumCtrl.text = widget.mInfo.mPnum.substring(_chosenValue.length+middlePNumCtrl.text.length+2);
    } else {
      _chosenValue = '010';
      middlePNumCtrl.text = '';
      endPNumCtrl.text = '';
    }
    
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(      
      appBar: getAppBar.returnAppBar(which: memberInfoAppbar),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/icons/Sign_Up_bg.svg",
            height: MediaQuery.of(context).size.height,
            // Now it takes 100% of our height
          ),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "내 정보 조회 및 수정",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),                    
                    const SizedBox(height: defaultPadding * 2),
                    printId(),
                    const SizedBox(height: defaultPadding * 2),
                    _modifyForm(),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate())  {
                            _formKey.currentState!.save();
                            _mPnum = getTotPNum();
                            
                            accessToDB.modifyMInfo(
                              mId: _mId, 
                              mName: _mName,
                              mEmail: _mEmail,
                              mPnum: _mPnum,
                            ).then((value) {
                                var json = jsonDecode(value);
                                if( json['code']=='success'){
                                  prefs.setString("mName", _mName);
                                  prefs.setString("mPnum", _mPnum);
                                  prefs.setString("mEmail", _mEmail);
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "수정 성공!", 
                                                  message: json['desc'],
                                                  nSort: toMyPage);
                                } else {
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "수정 실패!", 
                                                  message: '서버 에러입니다.',
                                                  // nSort: toLoginPage,
                                                  );
                                }
                              }
                            );
                          }
                        },
                        child: Text("Sign Up"),
                      ),
                    ),                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );    
  }

  Widget printId() {
    if(_mId.indexOf(naver)>-1||_mId.indexOf(kakao)>-1||_mId.indexOf(google)>-1||_mId.indexOf(facebook)>-1){
      return Row(
              children: [
                Text("아이디"),
                SizedBox(width: 10,),
                Text('sns 로그인 유저'),
              ],
            );
    } else {
      return Row(
              children: [
                Text("아이디"),
                SizedBox(width: 10,),
                Text(_mId),
              ],
            );
    }
    
  }

  Widget _modifyForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          TextFieldName(text: "이름"),
          TextFormField(
            initialValue: widget.mInfo.mName,
            decoration: InputDecoration(hintText: ""),
            validator: RequiredValidator(errorText: "이름은 필수 입력 사항입니다."),
            // Let's save our username
            onSaved: (name) => _mName = name!,
          ),
          const SizedBox(height: defaultPadding),          
          TextFieldName(text: "이메일 주소"),
          TextFormField(
            initialValue: widget.mInfo.mEmail,
            
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "test@email.com"),
            validator: EmailValidator(errorText: "유효한 메일 주소를 입력하세요."),
            onSaved: (email) => _mEmail = email!,
          ),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              TextFieldName(text: "핸드폰 번호"),
              SizedBox(width: phoneNumPadding,),
              SizedBox(width: phoneNumPadding,),
              DropdownButton <String>(              
              value:  _chosenValue,
              items: firstPNums.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint:const Text("010",),
              onChanged: (String? value) {
                print(value);
                setState(() {
                  _chosenValue = value!;
                });                
              },
            ),              
              SizedBox(width: phoneNumPadding,),
              SizedBox(
                width: phoneNumWidth,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    validator: phoneNumberValidator,
                    controller: middlePNumCtrl,
                    onChanged: (value) {
                      if(value.length>4) {
                        setState(() {
                          checkPNumCount(middlePNumCtrl);
                        });                      
                      }
                    },
                  )
              ),
              SizedBox(width: phoneNumPadding,),
              SizedBox(                
                width: phoneNumWidth,
                child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    validator: phoneNumberValidator,
                    controller: endPNumCtrl,
                    onChanged: (value) {
                      if(value.length>4) {
                        setState(() {
                          checkPNumCount(endPNumCtrl);
                        });                      
                      }
                    },
                  )                
                ),              
            ],
          ),
        ],
      ),    
    );
  }
  
  String getTotPNum() {
    String totPNum = '$_chosenValue-${middlePNumCtrl.text}-${endPNumCtrl.text}';

    return totPNum;
  }
}



class TextFieldName extends StatelessWidget {
  const TextFieldName({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 3),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }
}