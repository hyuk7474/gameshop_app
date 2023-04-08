import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/qna_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/card.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/write_button.dart';

class QnAMainPage extends StatefulWidget {

  static List<QnAInfo>? qnaList = [];
  late String mId;

  QnAMainPage({Key? key, required this.mId}) : super(key: key);

  @override
  State<QnAMainPage> createState() => QnAMainPageState();
}

class QnAMainPageState extends State<QnAMainPage> {
  
  GetAppBar getAppBar = GetAppBar();

  final ValueNotifier<List<QnAInfo>> _counter = ValueNotifier<List<QnAInfo>>([]);

  static List<QnAInfo> qnaList = [];

  @override
  void initState() {
    setState(() {
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: serviceAppbar),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Container(
              width:  double.infinity,              
              color: Colors.blueGrey[300],      
              child: tableText(),
            ),  
            checkList(),
          ],
        ) 
      ),
    );
  }

  Widget tableText() {
    return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  "문의사항을 남겨주시면 \n빠른 시일내로 답변을 드리겠습니다.👨‍💻",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                )
              ),
              color: Colors.white,
              ),
            Container(
              height: 30,
              child: Row(                        
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                                                            
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.black,
                            width: qnaBoardLine,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: qnaBoardLine,
                          ),
                        ),
                      ),
                      child: Center(child: Text('제목', textAlign: TextAlign.center,)),
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
                          bottom: BorderSide(
                            color: Colors.black,
                            width: qnaBoardLine,
                          ),
                        ),
                      ),                            
                      child: Center(child: Text('날짜', textAlign: TextAlign.center,))),
                  ),                         
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(                                    
                          bottom: BorderSide(
                            color: Colors.black,
                            width: qnaBoardLine,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text('상태', textAlign: TextAlign.center,),
                      ),
                    ),
                  ),             
                ],
              ),
            ),              
          ],
        ),
      );
  }

  Future<List<QnAInfo>> setList() async {
    return QnAMainPageState.qnaList;
  }

  Widget checkList() {
    if(QnAMainPageState.qnaList.isNotEmpty) {      
      return FutureBuilder(
        future: setList(),
        builder: (context, AsyncSnapshot<List<QnAInfo>> snapshot) {
          if(snapshot.hasData) {
            return CardList(qnaList: snapshot.data!, mId: widget.mId);
          }
          return CircularProgressIndicator();
        }
        );

    } else {
      return Container(
            width:  double.infinity,
            height: 300,
            color: Colors.blueGrey[100],    
            child: Column(
              children: [
                Expanded(flex:5, child: Center(child: Text('작성된 문의글이 없습니다.'))),
                Expanded(flex:1, child: WriteButton()),
              ],
            ),
          );
    }
  }
}