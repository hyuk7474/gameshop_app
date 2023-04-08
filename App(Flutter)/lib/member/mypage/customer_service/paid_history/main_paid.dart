import 'package:flutter/material.dart';
import 'package:shopping_ui/member/mypage/customer_service/paid_history/view_paid.dart';

class MainPaidPage extends StatefulWidget {
  const MainPaidPage({Key? key}) : super(key: key);

  @override
  State<MainPaidPage> createState() => _MainPaidPageState();
}

class _MainPaidPageState extends State<MainPaidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('구매 내역 메인 페이지 입니다.'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => ViewPaidPage())
                );
              }, 
              child: Text('상세 내역 페이지')
            )
          ],
        ),
      ),
    );
  }
}