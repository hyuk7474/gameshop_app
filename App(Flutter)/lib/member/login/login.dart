import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

import 'dart:convert';


import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as k;
import 'package:shopping_ui/member/join/join.dart';
import 'package:shopping_ui/member/login/components/sns_login_button.dart';

import 'package:shopping_ui/widgets/alert_dialog.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignIn _googleSignIn = GoogleSignIn(  
    scopes: <String>['email',],
  );

  bool loading = false;
  bool loginFormVisible = true;
  

  late SharedPreferences prefs;

  AccessToDB accessToDB = AccessToDB();
  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _mId, _mPw, _mName, _mEmail;
  

  @override
  void initState() {
    Firebase.initializeApp();
    getSharedPreferences();    
    super.initState();    
  }

  

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();    
  }

  Future<void> _loginWithFacebook() async {
    setState(() {
      loading = true;
      loginFormVisible = false;
    });

    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final FacebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);

      print(userData);
      _mId = userData['id'];
      _mEmail = userData['email'];
      _mName = userData['name'];
      print(_mEmail);
      print(_mName);
      print(_mId);

      await FirebaseFirestore.instance.collection('users').add({
        'email' : _mEmail,
        'imageUrl' : userData['picture']['data']['url'],
        'name' : _mName,
      });
    } on FirebaseAuthException catch (e) {
      print(e);      

      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Login with facebook failed'),
        content: Text('Failed'),
        actions: [TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text('Ok'))],
      ));
    } finally {
      setState(() {
        loading = false;
        loginFormVisible = true;
      });
    }
  }

  Future<void> loginWithNaver() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();

    print(res.errorMessage);
    
    if(res.errorMessage.indexOf('user_cancel')>-1) {
      showAlertDialog.showMyDialog(context: context, title: '연결 실패 🚧', message: '이 기능을 이용하기 위해서는 네이버 어플이 필요합니다.', nSort: installNaver);
    }    
    _mId = res.account.id;
    _mEmail = res.account.email;
    _mName = res.account.name;    
  }

  Future<void> loginWithKakao() async {
    try {
      k.OAuthToken token = await k.UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공 ${token.accessToken}');
      print('${token.idToken}');                      

      k.User user = await k.UserApi.instance.me();
      print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');

      _mId = user.id.toString();
      _mName = user.kakaoAccount?.profile?.nickname ?? '(kakao user)';
      _mEmail = user.kakaoAccount?.email ?? '(kakao user)';
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      if(error.toString().indexOf('KakaoTalk is installed but not connected to Kakao account.')>-1){
        showAlertDialog.showMyDialog(context: context, title: '연결 실패🚧', message: '카카오톡 어플의 사용자가 연결되있지 않습니다.');
      } else if(error.toString().indexOf('KakaoTalk is not installed.')>-1){
        showAlertDialog.showMyDialog(context: context, title: '연결 실패🚧', message: '이 기능을 이용하기 위해서는 카카오톡 어플이 필요합니다.', nSort: installKakao);
      }      
    };
  }

  

  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 3));

    // Close the dialog programmatically
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(                  
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 170,),
                          Dialog(
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [                          
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 15,
                                  ),                          
                                  Text('Loading...')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    visible: loading,
                  ),
                  Visibility(
                    visible: loginFormVisible,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _loginForm(),
                        const SizedBox(height: defaultPadding * 2),
                        Row(                  
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {                          
                                if (_formKey.currentState!.validate())  {
                                  // Sign up form is done
                                  // It saved our inputs                            
                                  _formKey.currentState!.save();  
                                  print(_mId);
                                  
                                  accessToDB.doLogin(mId: _mId)
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
                                          int enabled = json['data']['enabled'];
                          
                                          if(enabled==0) {
                                            whenLoginBanned();
                                          } else if(enabled==1) {
                                            whenLoginSucceed(json, _mId);
                                          }
                                        } else {
                                          whenMissmatched();
                                        }                                  
                                      } else {
                                          whenMissmatched();
                                        }
                                    }
                                  );
                                }
                              },
                              child: Text("로그인"),
                            ),
                            const SizedBox(width: defaultPadding * 2),
                            ElevatedButton(
                              onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinPage()),
                              ); 
                            }, 
                        child: Text('회원가입')
                        ),
                          ],
                        ),
                        SnsLoginButton(
                          color: Colors.green,
                          image: const AssetImage('assets/images/naver.png'), 
                          text: 'Login with Naver', 
                          onPressed:() async {    
                            loginWithNaver().then((value) {
                              snsLoginProcess(naver);
                            });
                          }
                        ),
                        SnsLoginButton(
                          color: Colors.orange,
                          image: const AssetImage('assets/images/kakao.png'), 
                          text: 'Login with Kakao', 
                          onPressed:() async {
                            loginWithKakao().then((value) {
                              snsLoginProcess(kakao);
                            });
                          }
                        ),
                        SnsLoginButton(
                          color: Colors.blue, 
                          image: const AssetImage('assets/images/facebook.png'), 
                          text: 'Login with Facebook', 
                          onPressed: () {
                            _loginWithFacebook().then((value) {
                              snsLoginProcess(facebook);
                            });                
                          }),
                        SnsLoginButton(
                          color: Colors.black,
                          image: const AssetImage('assets/images/google.png'), 
                          text: 'Login with Google', 
                          onPressed:() async {    
                            _handleSignIn().then((value) {                      
                              snsLoginProcess(google);
                            });               
                          }
                        ),                
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  void snsLoginProcess(String check) {    
    print('$_mId / $_mEmail');
    accessToDB.doLogin(mId: '$_mId$check')
      .then((value) async {        
        var json = jsonDecode(value);        
        if(json['code']=='success'){                    
          int enabled = json['data']['enabled'];

          if(enabled==0) {
            whenLoginBanned();
          } else if(enabled==1) {
            whenLoginSucceed(json, _mName);
            return;
          }
        } else if(json['code']=='fail') {
          print('not joined');
          print('process join');
          snsJoinProcess(check);          
        } else {
          showAlertDialog
          .showMyDialog(context: context, 
                        title: "로그인 실패😥", 
                        message: '서버 에러입니다.',                        
                        );
        }
      }
    );
  }

  void snsJoinProcess(String check) {        
    print('$_mId / $_mName / $_mEmail');                        
    accessToDB.doJoin(mId: '$_mId$check', mPw: 'snsuser', mName: _mName, mEmail: _mEmail)
    .then((value) {      
        var json = jsonDecode(value);
        if( json['code']=='success'){
          snsLoginProcess(check);          
        } else {
          showAlertDialog
            .showMyDialog(context: context, 
                          title: "가입 실패!", 
                          message: json['desc'],                                              
                          );
        }
      }
    );        
  } 

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn()
      .then((value) {
        print('handleSignIn');
        _mId = value!.id;
        _mName = value.displayName ?? '';
        _mEmail = value.email;
        
        print(value.displayName);
        print(value.email);
        print(value.id);
      });
    } catch (error) {
      print(error);
    }
  }

  void whenLoginSucceed(dynamic json, String idOrName) {
    var data = json['data'];

    prefs.setInt('status',1);
    prefs.setString("mId", data['mId']);
    prefs.setString("mName", data['mName']);
    prefs.setString("mPnum", data['mPnum'] ?? '');
    prefs.setString("mEmail", data['mEmail'] ?? '');
    prefs.setInt('mBlack', data['mBlack']);

    showAlertDialog
    .showMyDialog(context: context, 
                  title: "로그인 성공😀", 
                  message: '$idOrName 님 환영합니다.',
                  nSort: toMainPage,
                  );                              
  }

  void whenMissmatched() {
    showAlertDialog
    .showMyDialog(context: context, 
                  title: "로그인 실패😥", 
                  message: '아이디 혹은 비밀번호가 잘못되었습니다.',                  
                  );
  }

  void whenLoginBanned() {
    showAlertDialog
    .showMyDialog(context: context, 
                  title: "로그인 불가능😣", 
                  message: '로그인이 정지된 계정입니다.',                  
                  );
  }

  Widget _loginForm() {
      return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Container(
          //     height: 40.0,
          //     width: 40.0,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         width: 2,
          //         color: Color.fromARGB(255, 22, 100, 165),
          //       ),
          //     ),
          //     child: Icon(
          //       FlutterIcons.chevron_left_mco,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 30,),
          //   Container(
          //     margin: EdgeInsets.all(20),
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: accent
          //     ),
          //     child: Container(
          //       padding: EdgeInsets.all(100),
          //       margin: EdgeInsets.all(5),
          //       // height: 180,
          //       // width: 280,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: white,
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/raster/Kidult.png'),
          //           fit: BoxFit.scaleDown 
          //         ),
          //       ),
          //     ),
          //   ),
          SizedBox(height: 30,),
          TextFieldName(text: "아이디"),
          TextFormField(
            decoration: InputDecoration(hintText: "아이디를 입력하세요."),
            validator: RequiredValidator(errorText: "Username is required"),
            // Let's save our username
            onSaved: (mId) => _mId = mId!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "비밀번호"),

          TextFormField(
            // We want to hide our password
            obscureText: true,
            decoration: InputDecoration(hintText: "비밀번호를 입력하세요."),
            validator: passwordValidator,
            onSaved: (password) => _mPw = password!,
            // We also need to validate our password
            // Now if we type anything it adds that to our password
            onChanged: (pass) => _mPw = pass,
          ),                
        ],
      ),
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