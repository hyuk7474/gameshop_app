import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/constant/product/constants.dart';

class TitleWidget extends StatelessWidget {
  late String text;
  TitleWidget({Key? key, required this.text}) : super(key: key);

  @override  
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(text, style: TextStyle(fontSize: orderProcessMiddleFont),),
              );
  }
}


class LineToSeperate extends StatelessWidget {
  const LineToSeperate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                  border: Border(                    
                    bottom: BorderSide(
                      color: Colors.black,
                      width: qnaBoardLine,
                    ),
                  ),
                )
              );
    
  }
}