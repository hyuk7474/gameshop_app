import 'package:flutter/material.dart';

class ViewPaidPage extends StatefulWidget {
  const ViewPaidPage({Key? key}) : super(key: key);

  @override
  State<ViewPaidPage> createState() => _ViewPaidPageState();
}

class _ViewPaidPageState extends State<ViewPaidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('상세 구매 내역 확인 페이지 입니다.')),
    );
  }
}