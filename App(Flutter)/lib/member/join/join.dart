import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/login/login.dart';
import 'package:shopping_ui/member/check_login.dart';
import 'package:shopping_ui/product/pages/home_screen.dart';

import 'package:shopping_ui/widgets/alert_dialog.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shopping_ui/constant/member/constants.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  ShowAlertDialog showAlertDialog = ShowAlertDialog();
  AccessToDB accessToDB = AccessToDB();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late String _mId, _mPw, _mName, _mEmail, _mPnum;    

  String _chosenValue = '010';
  

  TextEditingController phonenumCtrl  = TextEditingController();

  TextEditingController startPNumCtrl = TextEditingController();
  TextEditingController middlePNumCtrl = TextEditingController();
  TextEditingController endPNumCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {    
    return Scaffold(      
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 22, 100, 165),
                          ),
                        ),
                        child: Icon(
                          FlutterIcons.chevron_left_mco,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "회원 가입",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              )),
                          child: Text(
                            "로그인",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    _joinForm(),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {                          
                          if (_formKey.currentState!.validate())  {                                                       
                            _formKey.currentState!.save();
                            _mPnum = getTotPNum();
                            var salt = await FlutterBcrypt.salt();
                            String hashedPw = await FlutterBcrypt.hashPw(password: _mPw, salt: salt);                            
                            print("hashedPw: $hashedPw");
                            accessToDB.doJoin(mId: _mId, 
                                              mPw: '{bcrypt}'+hashedPw, 
                                              mName: _mName,
                                              mEmail: _mEmail,
                                              mPnum: _mPnum,
                                            )
                              .then((value) {
                                var json = jsonDecode(value);
                                if( json['code']=='success'){
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "가입 성공!", 
                                                  message: json['desc'],
                                                  nSort: toLoginPage);
                                } else {
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "가입 실패!", 
                                                  message: json['desc'],
                                                  // nSort: toLoginPage,
                                                  );
                                }
                              }
                            );
                          }
                        },
                        child: Text("가입"),
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


  Widget _joinForm() {
      return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "아이디"),
          TextFormField(
            decoration: InputDecoration(hintText: "theflutterway"),
            validator: RequiredValidator(errorText: "아이디는 필수 입력 사항입니다."),
            // Let's save our username
            onSaved: (mId) => _mId = mId!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "비밀번호"),

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
          TextFieldName(text: "이름"),
          TextFormField(
            decoration: InputDecoration(hintText: ""),
            validator: RequiredValidator(errorText: "이름은 필수 입력 사항입니다."),
            // Let's save our username
            onSaved: (name) => _mName = name!,
          ),
          const SizedBox(height: defaultPadding),
          // We will fixed the error soon
          // As you can see, it's a email field
          // But no @ on keybord
          TextFieldName(text: "이메일 주소"),
          TextFormField(
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
    late String totPNum;

    print(middlePNumCtrl.text);

    if(middlePNumCtrl.text!=''&&endPNumCtrl.text!=''){
      totPNum = '$_chosenValue-${middlePNumCtrl.text}-${endPNumCtrl.text}';
    } else {
      totPNum ='';
    }
    

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