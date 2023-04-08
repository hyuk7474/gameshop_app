import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/member/join/join.dart';
import 'package:shopping_ui/member/login/login.dart';
import 'package:shopping_ui/product/pages/cart_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:shopping_ui/product/pages/category/cart_list.dart';

class CartTempMain extends StatefulWidget {
  const CartTempMain({Key? key}) : super(key: key);

  @override
  State<CartTempMain> createState() => _CartTempMainState();
}

class _CartTempMainState extends State<CartTempMain> with WidgetsBindingObserver{

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
    
    setState(() {
      _lastLifecycleState = state;
    });
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    
    status = (prefs.getInt('status') ?? 0);
    mId = (prefs.getString("mId") ?? '');      
    mName = (prefs.getString("mName") ?? '');
    mPnum = (prefs.getString("mPnum") ?? ''); 
    mEmail = (prefs.getString("mEmail") ?? '');
    mBlack = (prefs.getInt("mBlack") ?? 0);

    print('$status / $mId / $mName / $mPnum / $mBlack / $mEmail');    
  }


  @override
  Widget build(BuildContext context) {
    if(status==1){
      return CartList();
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,            
            children: [
              Text('로그인 후 이용 가능합니다', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('회원이 아니시라면'),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinPage()),
                    ); 
                  }, 
                    child: Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('회원 이시라면'),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage()),
                    ); 
                  }, 
                    child: Text('로그인', style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SNS로그인으로 이용하시려면'),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage()),
                    ); 
                    }, 
                    child: Text('social Login', style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(primary: accent),
                  ),
                ],
              ),
              Text('으로 이동해 주세요'),
            ],
          ),
        )
        ,
      );
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

