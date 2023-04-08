import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/member/join/join.dart';
import 'package:shopping_ui/member/login/login.dart';
import 'package:shopping_ui/member/mypage/mypage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> with WidgetsBindingObserver{

  AppLifecycleState? _lastLifecycleState=null;


  late SharedPreferences prefs;

  late String mId, mName, mPnum, mEmail;
  late int mBlack;
  int status=0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    print('disposed');
    WidgetsBinding.instance.removeObserver(this); // (3)
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {	// (4)
    switch (state) {
      case AppLifecycleState.detached:	// (5)
        print("## detached");
        prefs.clear();
        break;
      case AppLifecycleState.inactive:	// (6)
        print("## inactive");
        break;
      case AppLifecycleState.paused:	// (7)
        print("## paused");
        break;
      case AppLifecycleState.resumed:	// (8)
        print("## resumed");
        break;
    }
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    
    status = (prefs.getInt('status') ?? 0);
    mId = (prefs.getString("mId") ?? '');      
    mName = (prefs.getString("mName") ?? '');
    mPnum = (prefs.getString("mPnum") ?? ''); 
    mEmail = (prefs.getString("mEmail") ?? '');
    mBlack = (prefs.getInt("mBlack") ?? 0);

    print('check login');
    print('$status / $mId / $mName / $mPnum / $mBlack / $mEmail');    
  }


  @override
  Widget build(BuildContext context) {
    if(status==1){
      return MypagePage();
    } else {
      return LoginPage();
    }
      
  }

  Widget statustText() {
    if (_lastLifecycleState == null) {
      return Text(
        'This widget has not observed any lifecycle changes.',
        textDirection: TextDirection.ltr,
      );
    } else {
      return Text(
        'The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
        textDirection: TextDirection.ltr,
      );
    }
  }
}

