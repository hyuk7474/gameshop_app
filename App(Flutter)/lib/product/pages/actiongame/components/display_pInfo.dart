import 'package:flutter/material.dart';
import 'package:shopping_ui/product/components/detail.dart';

class DisplayPInfo extends StatelessWidget {
  late DetailInfo pInfo;
  DisplayPInfo({Key? key, required this.pInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                width: double.infinity,                
                child: Row(
                  children: [
                    Expanded(                    
                      flex: 2,
                      child: Container(                                                                    
                        child: Image.network(pInfo.imgurl),
                        // Image(image: AssetImage("assets/images/temp/kirby.jpg"))
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          children: [
                            Text(pInfo.title),
                            Text('${getPriceString(pInfo.hashCode)} 원', textAlign: TextAlign.center,),                          
                          ],
                        ),
                      ),
                    ),                    
                  ],
                )
              );
  }

  String getPriceString(num num) {    
    String result = num.toString();

    int iCheck = result.indexOf('.');

    if(iCheck>-1) result = result.substring(0, iCheck);
    print(result);
    if(result.length>3) {
      int restStr = result.length % 3;
      if(restStr == 0) {
        result = plusComma(result, 0);        
      } else if(restStr == 1) {
        result = plusComma(result, 1);
        
      } else if(restStr == 2) {
        result = plusComma(result, 2);
        
      }
    }    
    return result;
  }

  String plusComma(String str, int num) {
    String result = '';

    String frontStr = '';    

    if(num==1||num==2){
      frontStr = '${str.substring(0,num)},';
      str = str.substring(num);
    }

    int iDivided = str.length ~/ 3;

    for(int i=0; i<iDivided;i++) {
      String temp = '';      
      temp = '${str.substring(i*3,i*3+3)},';      
      result = result + temp;
    }

    result = '$frontStr${result.substring(0,result.length-1)}';

    return result;
  }
}
