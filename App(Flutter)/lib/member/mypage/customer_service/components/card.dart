import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/qna_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/write_button.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/view_qna.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/write_qna.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';

class CardList extends StatefulWidget {  
  late List<QnAInfo> qnaList;
  late String mId;
  
  CardList({
    Key? key,
    required this.qnaList,
    required this.mId,
    }) : super(key: key);

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
              width:  double.infinity,            
              color: Colors.blueGrey[100],    
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                itemCount: widget.qnaList.length,
                itemBuilder: (BuildContext context, int index){
                  return PersonTile(widget.qnaList[index], index, widget.mId, widget.qnaList.length);
                }
              ),
            ),
    );
  }
}

class PersonTile extends StatelessWidget{
  final int qnaListSize;
  final QnAInfo qInfo;
  final int index;
  final String _mId;  
  
  PersonTile(this.qInfo, this.index, this._mId, this.qnaListSize);

  AccessToDB accessToDB = AccessToDB();
  ShowAlertDialog showAlertDialog = ShowAlertDialog();

  String getQContent() {
    String qContent = qInfo.qContent;
    if(qContent.length > 10) qContent = '${qContent.substring(0, 9)}...';
    if(qContent.indexOf('\n')>-1) qContent = '${qContent.substring(0, qContent.indexOf('\n'))}...';
    return qContent;
  }  

  String getQDate() {
    String qDate = qInfo.qDate.substring(2, 10);
    return qDate;
  }

  Widget getQRead() {
    String qRead = qInfo.qRead;
    if(qRead=='1') return Text('읽음', style: TextStyle(color: Colors.green), textAlign: TextAlign.center);
    else return Text('읽지 않음', style: TextStyle(color: Colors.red), textAlign: TextAlign.center);
  }

  Widget writeButton(BuildContext context) {    
    if(index==qnaListSize-1){      
    return WriteButton();
    } else return Visibility(visible: false, child: Text('null'));
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: qnaListTileHeight,        
          child: Row(          
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [                                
              Expanded(
                flex: 2,
                child: Container(   
                  height: qnaListTileHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black,
                        width: qnaBoardLine,
                      ),                  
                    ),
                  ),                 
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ViewQnAPage(qInfo: qInfo))
                        )
                      );
                    },
                    child: Text(qInfo.qTitle)),
                ),
              ),
              Expanded(                      
                child: Container(                     
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black,
                        width: qnaBoardLine,
                      ),                  
                    ),
                  ),
                  child: Center(child: Text(getQDate(), textAlign: TextAlign.center,))
                ),
              ),
              Expanded(              
                child: Container(                            
                  child: getQRead(),
                ),
              ),              
            ],
          )             
        ),
        writeButton(context),        
      ],
      
    );   
  }
}