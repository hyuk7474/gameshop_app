import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/constant/theme/colors.dart';

class GetAppBar{

  AppBar returnAppBar({required int which}) {
    
    String title = '';
    if(which==serviceAppbar) title = '고객센터';
    else if(which==memberInfoAppbar) title = "회원 정보";
    else if(which==orderAppbar) title = "주문 정보";

    return AppBar(        
        shadowColor: accent,
        backgroundColor: bar,
        title: Text(
          title,
          style: TextStyle(color: accent),
        ),
      );    
  }

  AppBar returnAppBarByTitle({required String title}) {
    
    return AppBar(        
        shadowColor: accent,
        backgroundColor: bar,
        title: Text(
          title,
          style: TextStyle(color: accent),
        ),
      );    
  }
}