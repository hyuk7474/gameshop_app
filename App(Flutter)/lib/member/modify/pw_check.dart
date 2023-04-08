import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';




import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as k;
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/components/member_info.dart';
import 'package:shopping_ui/member/login/components/sns_login_button.dart';


import 'package:shopping_ui/widgets/alert_dialog.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/constant/member/constants.dart';



class PWCheckPage extends StatefulWidget {
  late MemberInfo mInfo;
  PWCheckPage({Key? key, required this.mInfo}) : super(key: key);

  @override
  State<PWCheckPage> createState() => _PWCheckPageState();
}

class _PWCheckPageState extends State<PWCheckPage> {

  GetAppBar getAppBar = GetAppBar();
  
  AccessToDB accessToDB = AccessToDB();
  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GoogleSignIn _googleSignIn = GoogleSignIn(  
    scopes: <String>['email',],
  );

  late String _checkId, _mId, _mPw;

  @override
  void initState() {    
    _mId = widget.mInfo.mId;
    super.initState();    
  }
  

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: getAppBar.returnAppBar(which: memberInfoAppbar),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정보 조회 및 수정을 위하여',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '본인 인증이 필요합니다.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 25,),
              _pwCheckForm(),
            ],
          )
          
        ),
      );
  }


  Widget _pwCheckForm() {
    if(_mId.indexOf(naver) > -1){
      return SnsLoginButton(
                  color: Colors.green,
                  image: const AssetImage('assets/images/naver.png'), 
                  text: 'Login with Naver', 
                  onPressed:() async {    
                    loginWithNaver().then((value) {
                      snsVerifyProcess(naver);
                    });
                  }
                );
    } else if(_mId.indexOf(kakao) > -1){
      return SnsLoginButton(
                  color: Colors.orange,
                  image: const AssetImage('assets/images/kakao.png'), 
                  text: 'Login with Kakao', 
                  onPressed:() async {
                    try {
                      loginWithKaKao().then((value) {
                        snsVerifyProcess(kakao);                        
                      });
                    } catch (error) {
                      print('카카오톡으로 로그인 실패 $error');
                      if(error.toString().indexOf('KakaoTalk is installed but not connected to Kakao account.')>-1){
                        showAlertDialog.showMyDialog(context: context, title: '연결 실패🚧', message: '카카오톡 어플의 사용자가 연결되있지 않습니다.');
                      } else if(error.toString().indexOf('KakaoTalk is not installed.')>-1){
                        showAlertDialog.showMyDialog(context: context, title: '연결 실패🚧', message: '이 기능을 이용하기 위해서는 카카오톡 어플이 필요합니다.', nSort: installKakao);
                      }
                      
                    };
                  }
                );
    } else if(_mId.indexOf(google) > -1){
      return SnsLoginButton(
                  color: Colors.black,
                  image: const AssetImage('assets/images/google.png'), 
                  text: 'Login with Google', 
                  onPressed:() async {    
                    _handleSignIn().then((value) {                      
                      snsVerifyProcess(google);
                    });                    
                                      
                  }
                );
    } else if(_mId.indexOf(facebook) > -1){
      return SnsLoginButton(
                  color: Colors.blue, 
                  image: const AssetImage('assets/images/facebook.png'), 
                  text: 'Login with Facebook', 
                  onPressed: () {
                    _loginWithFacebook().then((value) {
                      snsVerifyProcess(facebook);
                    });                
                  });
    } else {
      return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [          
          TextFieldName(text: "비밀번호"),
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
                            whenVerified();
                          } else {
                            showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "인증 실패😥", 
                                          message: '비밀번호가 일치하지 않습니다.',
                                          // nSort: toPWCheckPage,
                                          );
                          }                                  
                        } else {
                            showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "서버 에러😫", 
                                          message: '서버 에러입니다.',
                                          // nSort: toPWCheckPage,
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

  void whenVerified() {
    showAlertDialog
    .showMyDialog(context: context, 
                  title: "인증 성공😀", 
                  message: '내 정보 수정페이지로 이동합니다.',
                  nSort: toModifyPage,
                  mInfo: widget.mInfo,
                  );
  }

  Future<void> loginWithKaKao() async {
    k.OAuthToken token = await k.UserApi.instance.loginWithKakaoTalk();
                      print('카카오톡으로 로그인 성공 ${token.accessToken}');
                      print('${token.idToken}');
                      k.User user = await k.UserApi.instance.me();
                      print('사용자 정보 요청 성공'
                            '\n회원번호: ${user.id}'
                            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
                            '\n이메일: ${user.kakaoAccount?.email}');

                      _checkId = user.id.toString();
  }

  Future<void> loginWithNaver() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();

    print(res.errorMessage);
    
    if(res.errorMessage.indexOf('user_cancel')>-1) {
      showAlertDialog.showMyDialog(context: context, title: '연결 실패 🚧', message: '이 기능을 이용하기 위해서는 네이버 어플이 필요합니다.');
    }

    print('-----------------------------');    
    print(res);
    _checkId = res.account.id;
    print('-----------------------------');    
  }

  Future<void> _loginWithFacebook() async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final FacebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);

      
      _checkId = userData['id'];
      
      print(_checkId);
      
    } on FirebaseAuthException catch (e) {
      print(e);      
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Login with facebook failed'),
        content: Text('Failed'),
        actions: [TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text('Ok'))],
      ));
    } 
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn()
      .then((value) {
        print('handleSignIn');
        _checkId = value!.id;

        print(_checkId);
      });
    } catch (error) {
      print(error);
    }
  }

  void snsVerifyProcess(String check) {        
    accessToDB.doLogin(mId: '$_checkId$check')
      .then((value) async {
        print("Value: $value");
        var json = jsonDecode(value);
        print(json);
        if(json['code']=='success'){                    
          String idcheck = json['data']['mId'];
          print(idcheck);
          print(_mId);

          if(idcheck==_mId) {
            whenVerified();
          } else {
            whenSnsVerifiedFailed();  
          }
        } else {
          whenSnsVerifiedFailed();
        }
      }
    );
  }

  void whenSnsVerifiedFailed() {
    showAlertDialog
    .showMyDialog(context: context, 
                  title: "인증 실패😥", 
                  message: '인증할 sns 계정을 확인해주세요.',                      
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