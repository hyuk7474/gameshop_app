import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/mypage/customer_service/components/qna_info.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/main_qna.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/modify_qna.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';

class ViewQnAPage extends StatefulWidget {

  late QnAInfo qInfo;

  ViewQnAPage({Key? key, required this.qInfo}) : super(key: key);

  @override
  State<ViewQnAPage> createState() => _ViewQnAPageState();
}

class _ViewQnAPageState extends State<ViewQnAPage> {

  List<File> pList = [];

  late QnAInfo qInfo = widget.qInfo;
  GetAppBar getAppBar = GetAppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: serviceAppbar),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: qnaViewTileHeight,
                  child: textWidget('제목', qInfo.qTitle, 1),
                ),
                Container(
                  height: qnaViewTileHeight,
                  child: textWidget('날짜', qInfo.qDate, 1),
                ),
                Container(
                  height: qContentHeight,
                  child: textWidget('내용', qInfo.qContent, 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ShowAlertDialog showAlertDialog = ShowAlertDialog();
                        AccessToDB accessToDB = AccessToDB();
                        accessToDB.deleteQnA(qId: qInfo.qId)
                        .then((value) {
                        var json = jsonDecode(value);
                        if( json['code']=='success'){                          
                          showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "삭제 완료🐱‍🐉", 
                                          message: json['desc'],                                              
                                          nSort: toQnAMainPage,
                                          mId: qInfo.mId,                                          
                                          );
                        } else {
                          showAlertDialog
                            .showMyDialog(context: context, 
                                          title: "삭제 실패😣", 
                                          message: json['desc'],                                          
                                          );
                        }
                      });
                      }, 
                      child: Text('삭제'),
                      style: ElevatedButton.styleFrom(primary: Colors.red)
                    ),
                    SizedBox(width: defaultPadding,),
                    ElevatedButton(
                      onPressed: () {
                        setPhotosList().then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifyQnaPage(qInfo: widget.qInfo, pList: value)
                            )
                          );
                        });
                      }, 
                      child: Text('수정')),
                    SizedBox(width: defaultPadding,),                    
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );    
  }

  Future<List<File>> setPhotosList() async {    
    if(qInfo.qPhoto1!='null') await imageToFile(imageName: qInfo.qPhoto1).then((value) => pList.add(value));    
    if(qInfo.qPhoto2!='null') await imageToFile(imageName: qInfo.qPhoto2).then((value) => pList.add(value));    
    if(qInfo.qPhoto3!='null') await imageToFile(imageName: qInfo.qPhoto3).then((value) => pList.add(value));

    return pList;    
  }

  Future<File> imageToFile({required String imageName}) async {
    final ByteData imageData = await NetworkAssetBundle(Uri.parse('$serverAddress/upload/$imageName')).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/$imageName');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  Widget loadPhoto(int index) {
    if(index==1){
      return Container();
    } else {
      return Row(
                  children: [
                    SizedBox(width: defaultPadding,),
                    Expanded(child: checkPhoto(qInfo.qPhoto1)),
                    SizedBox(width: defaultPadding,),
                    Expanded(child: checkPhoto(qInfo.qPhoto2)),
                    SizedBox(width: defaultPadding,),
                    Expanded(child: checkPhoto(qInfo.qPhoto3)),
                    SizedBox(width: defaultPadding,),
                  ],
                );
    }    
  }

  Widget checkPhoto(String qPhoto) {
    if(qPhoto!='null') {
      return Container(        
        child: Image.network(
          '$serverAddress/upload/${qPhoto}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const LinearProgressIndicator();
            // You can use LinearProgressIndicator or CircularProgressIndicator instead
          },
        )
      );
    } else {
      return Visibility(child: Container());
    }
    
  }

  Widget textWidget(String th, String td, int num) {
    return Row(                        
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(                    
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: qnaBoardLine,
                ),
                left: BorderSide(
                  color: Colors.black,
                  width: qnaBoardLine,
                ),
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
            child: Center(child: Text(th, textAlign: TextAlign.center,)),
          ),
        ),
        Expanded(        
          flex: 5,                      
          child: Container(
            height: qContentHeight,   
            decoration: BoxDecoration(              
              border: Border(         
                top: BorderSide(
                  color: Colors.black,
                  width: qnaBoardLine,
                ),
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
            child: getTD(td, num),
          ),
        )          
      ],
    );
  }

  Widget getTD(String td, int num) {
    if(num==2) {
      return SingleChildScrollView(
        child: Column(
                children: [                
                  Padding(                  
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Text(td),
                  ),
                  SizedBox(height: defaultPadding,)
                  ,
                  loadPhoto(num),
                  // SizedBox(height: 100,)
                ],
              ),
      );
    } else {
      return Center(child: Text(td));
    }
  }
}