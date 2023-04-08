import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/member/carttemp.dart';
import 'package:shopping_ui/member/check_login.dart';
import 'package:shopping_ui/product/pages/category/cart_list.dart';
import 'package:shopping_ui/product/pages/category_page.dart';
import 'package:shopping_ui/product/pages/cart_page.dart';
import 'package:shopping_ui/product/pages/home_page.dart';
import 'package:shopping_ui/product/pages/search_page.dart';
import 'package:shopping_ui/product/pages/gamesearch_page.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/pages/search_page2.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {

  RemoteMessage? _message;
  String _myText = '';
  
  void setToken(String? token) {
    print('FCM Token: $token');
  }

  @override
  void initState() {
    super.initState();    
    FirebaseMessaging.instance.getInitialMessage()
      .then((RemoteMessage? message) {        
        print(message?.data['message']);
        if (message != null) {
          _message = message;
        }      
      });
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {      
      print('bbbbbb ======================================');
      if (message.data['message'] != null) {
        print(message.data['message']);  // 서버에서 푸시 메시지에 사용한 키 값
        callSanckBar(message.data['message']);
      } else {
        print('bbbbbb bbbbbb ===============================');
      }      
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('cccccc ======================================');
      print(message.data['message']);
      _message = message;
    });
 
    // 폰의 토큰을 앱 실행시마다 구해온다.
    FirebaseMessaging.instance
      .getToken(vapidKey:
        '') // secret key
      .then(setToken);
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    // _tokenStream.listen(setToken);
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print('Subscribing to topic "fcm_test" successful.');
        }
        break;
      case 'unsubscribe':
        {
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print('Unsubscribing from topic "fcm_test" successful.');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            print('Got APNs token: $token');
          } else {
            print('Getting an APNs token is only supported on iOS and macOS platforms.');
          }
        }
        break;
      default:
        break;
    }
  }
  String name = "";
  final TextEditingController _controller = new TextEditingController();
  
  int activeTab = 0;
  // appbar
  AppBar? appbar = null;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: white,
        bottomNavigationBar: getFooter(),
        appBar: getAppBar(),
        body: getBody(),
      ),
    );     
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await _showExitBottomSheet(context);
    return exitResult ?? false;
  }

  Future<bool?> _showExitBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: _buildBottomSheet(context),
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          '[GameShop] 어플을 종료하시겠습니까?',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('종료', style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ],
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(),
        GameSearchPage(),
        CategoryPage(),
        CheckLogin(),
        CartTempMain()
      ],
    );
  }

  AppBar? getAppBar() {
    switch (activeTab) {
      case 0:
        return AppBar(
          elevation: 1, //그림자
          shadowColor: accent,
          backgroundColor: bar,
          // title: Text(
          //   "Kidult",
          //   style: TextStyle(color: accent),
          // ), 
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/raster/Kidult.png'),
                fit: BoxFit.contain 
              ),
            ),
          ),
          //leading: IconButton(icon: Icon(Icons.search),),
          actions: <Widget> [
              IconButton(
                  onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const Search2Page())),
                  icon: Icon(Icons.search), color: accent,),
            ],
        );
        break;
      case 1:
        return AppBar(
          elevation: 1, //그림자
          shadowColor: accent,
          backgroundColor: bar,
          title: Text(
            "Search",
            style: TextStyle(color: accent),
          ),
        );
        break;
      case 2:
        return AppBar(
          elevation: 1, //그림자
          shadowColor: accent,
          backgroundColor: bar,
          title: Text(
            "Category",
            style: TextStyle(color: accent),
          ),
        );
        break;
      case 3:
        return AppBar(
          elevation: 1, //그림자
          shadowColor: accent,
          backgroundColor: bar,
          title: Text(
            "MyPage",
            style: TextStyle(color: accent),
          ),
        );
        break;
      case 4:
        return AppBar(
          elevation: 1, //그림자
          shadowColor: accent,
          backgroundColor: bar,
          title: Text(
            "Cart",
            style: TextStyle(color: accent),
          ),
        );
        break;
      default:
    }
  }

  Widget getFooter() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 212, 246, 255),
          border: Border(top: BorderSide(color: Color.fromARGB(255, 95, 208, 236).withOpacity(0.5)))),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 6),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(itemsTab.length, (index) {
              return IconButton(
                  icon: Icon(
                    itemsTab[index]['icon'],
                    size: itemsTab[index]['size'],
                    color: activeTab == index ? accent : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      activeTab = index;
                    });
                  });
            })),
      ),
    );
  }

  callSanckBar(msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: TextStyle(color: Colors.black,)),
          backgroundColor: Colors.yellow[800],
          duration: Duration(milliseconds: 10000),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.black,
            onPressed: () {},
          ),
          // behavior: SnackBarBehavior.floating,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   side: BorderSide(
          //     color: Colors.red,
          //     width: 2,
          //   ),
          // ),
      ),
    );  
  }
}

class MySearchDelegate extends SearchDelegate{
    @override
    Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    
    @override
    List<Widget> buildActions(BuildContext context) => [
      IconButton
      (
        icon: const Icon(Icons.close),
        onPressed: () {
          if(query.isEmpty) {
            close(context, null);
          } else {
            query = '';  
          }
        },
      ),
    ];
      
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      throw UnimplementedError();
    }
    
    @override
    Widget buildSuggestions(BuildContext context) {
      // TODO: implement buildSuggestions
      throw UnimplementedError();
    }

    
}