import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';




import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/components/member_info.dart';
import 'package:shopping_ui/member/login/components/sns_login_button.dart';


import 'package:shopping_ui/widgets/alert_dialog.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/constant/member/constants.dart';



class ModifyPW extends StatefulWidget {
  late MemberInfo mInfo;
  ModifyPW({Key? key, required this.mInfo}) : super(key: key);

  @override
  State<ModifyPW> createState() => _ModifyPWState();
}

class _ModifyPWState extends State<ModifyPW> {

  GetAppBar getAppBar = GetAppBar();
  
  AccessToDB accessToDB = AccessToDB();
  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _modifyPWKey = GlobalKey<FormState>();

  bool bCheckForm = true;
  bool bModifyForm = false;
  

  
  late String _mId, _mPw;

  @override
  void initState() {    
    _mId = widget.mInfo.mId;
    super.initState();    
  }
  

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: getAppBar.returnAppBar(which: memberInfoAppbar),
        body: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [      
                  Text(
                    '비밀 번호 변경🕵️‍♀️',
                    style: TextStyle(fontSize: 24),
                  ),          
                  Visibility(
                    visible: bCheckForm,
                    child: Column(
                      children: [                      
                        SizedBox(height: 25,),
                        _pwCheckForm(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: bModifyForm,
                    child: Column(
                      children: [                      
                        modifyPWForm()
                      ],
                    )
                  ),
                ],
              ),
            )
            
          ),
        ),
      );
  }


  Widget _pwCheckForm() {
    if(_mId.indexOf(naver) > -1||_mId.indexOf(kakao) > -1||_mId.indexOf(google) > -1||_mId.indexOf(facebook) > -1){
      return Text('snu로그인 유저는 비밀번호를 변경할 수 없습니다.');
    } else {
      return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [          
          TextFieldName(text: "변경할 비밀번호"),
          TextFormField(            
            obscureText: true,
            decoration: InputDecoration(hintText: "비밀번호를 입력하세요."),
            validator: passwordValidator,
            onSaved: (password) => _mPw = password!,            
            onChanged: (pass) => _mPw = pass,
          ),
          const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: () async {                          
                  if (_formKey.currentState!.validate())  {
                    // Sign up form is done
                    // It saved our inputs                            
                    _formKey.currentState!.save();                               
                    
                    accessToDB.doLogin(mId: widget.mInfo.mId,)
                      .then((value) async {
                        print("Value: $value");
                        var json = jsonDecode(value);
                        print(json);
                        if( json['code']=='success'){
                          String dataPW=json['data']['mPw'];
                          String hasedPW=dataPW.substring('{bcrypt}'.length);                                    

                          var verified = await FlutterBcrypt.verify(password: _mPw, hash: hasedPW);

                          print(verified);                                 

                          if(verified) {         
                            setState(() {
                              bCheckForm=false;
                              bModifyForm=true;
                            }); 
                            
                            showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "인증 성공😁", 
                                          message: '변경할 비밀번호를 입력해주세요.',                                  
                                          );
                          } else {
                            showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "인증 실패😥", 
                                          message: '비밀번호가 일치하지 않습니다.',                                  
                                          );
                          }                                  
                        } else {
                            showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "서버 에러😫", 
                                          message: '서버 에러입니다.',
                                          // nSort: toModifyPW,
                                          );
                          }
                      }
                    );
                  }
                },
                child: Text("비밀번호 입력"),
              ),            
          ],
        ),
      );
    }
  }

  Widget modifyPWForm() {
    return Form(
      key: _modifyPWKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          TextFieldName(text: "변경할 비밀번호"),
          TextFormField(
            // We want to hide our password
            obscureText: true,
            decoration: InputDecoration(hintText: "영문, 특수문자, 숫자를 포합하여 4~10자리 입력"),
            validator: passwordValidator,
            onSaved: (password) => _mPw = password!,
            // We also need to validate our password
            // Now if we type anything it adds that to our password
            onChanged: (pass) => _mPw = pass,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "비밀번호 확인"),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(hintText: "비밀번호를 한 번 더 입력하세요."),
            validator: (pass) => MatchValidator(errorText: "비밀번호가 일치하지 않습니다.").validateMatch(pass!, _mPw),
          ),
          const SizedBox(height: defaultPadding),  
          Center(
            child: ElevatedButton(
              onPressed: () async {                          
                if (_modifyPWKey.currentState!.validate())  {                                                       
                  _modifyPWKey.currentState!.save();                
                  
                  accessToDB.doLogin(mId: widget.mInfo.mId,)
                    .then((value) async {
                      print("Value: $value");
                      var json = jsonDecode(value);
                      print(json);
                      if( json['code']=='success'){
                        String dataPW=json['data']['mPw'];
                        String hasedPW=dataPW.substring('{bcrypt}'.length);

                        var verified = await FlutterBcrypt.verify(password: _mPw, hash: hasedPW);

                        print(verified);                                 

                        if(verified) {         
                          showAlertDialog.showMyDialog(context: context, title: '비밀번호 일치', message: '기존 비밀번호와 다른 비밀번호를 입력하세요.');
                          return;
                        } else {
                          var salt = await FlutterBcrypt.salt();
                          String hashedPw = await FlutterBcrypt.hashPw(password: _mPw, salt: salt); 
                          accessToDB.modifyPW(mPw: '{bcrypt}'+hashedPw, 
                                              mId: widget.mInfo.mId)
                          .then((value) async {

                            print("Value: $value");
                            var json = jsonDecode(value);
                            print(json);

                            if( json['code']=='success'){                                
                                showAlertDialog
                                .showMyDialog(context: context, 
                                              title: "변경 성공😁", 
                                              message: json['desc'],
                                              nSort: toMainPage
                                              );
                              } else {
                                showAlertDialog
                                .showMyDialog(context: context, 
                                              title: "변경 실패😥", 
                                              message: json['desc'],
                                              );
                              }                                  
                            });
                        }
                      }
                    }
                  );
                }
              },                    
              child: Text("비밀번호 변경"),
            ),
          ),                
        ],
      ),
    );
  }

  void whenVerified() {
    showAlertDialog
    .showMyDialog(context: context, 
                  title: "인증 성공😀", 
                  message: '내 정보 수정페이지로 이동합니다.',
                  nSort: toModifyPage,
                  mInfo: widget.mInfo,
                  );
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