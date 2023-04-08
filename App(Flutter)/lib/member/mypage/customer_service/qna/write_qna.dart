import 'dart:convert';
import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';


class QnaWritePage extends StatefulWidget {
  const QnaWritePage({Key? key}) : super(key: key);

  @override
  State<QnaWritePage> createState() => _QnaWritePageState();
}

class _QnaWritePageState extends State<QnaWritePage> {

  late String _mId, _qTitle, _qContent;

  GetAppBar getAppBar = GetAppBar();

  late SharedPreferences prefs;

  final ImagePicker _picker = ImagePicker();
  File? mPhoto1;
  File? mPhoto2;
  File? mPhoto3;
 
  late Widget photo1, photo2, photo3;

  List<String> _images = [];  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _mId = prefs.getString('mId') ?? 'id is not loaded';
  }

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  void deleteExPhoto(int index) {
    setState(() {
          if(index==1) mPhoto1 = null;
          if(index==2) mPhoto2 = null;
          if(index==3) mPhoto3 = null;
        });
  }

  void takePhoto(ImageSource source, int index) async {
    final XFile? image = await _picker.pickImage(source: source);
    // image = await _picker.pickImage(source: source);
    if(image!=null){
      cropImage(image.path, index);      
    }
  }

  Future<void> cropImage(String imagePath, int index) async {
    const MAX_WIDTH = 1920;
    const MAX_HEIGHT = 1080;
    const COMPRESS_QUALITY = 75;

    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imagePath, // 이미지 경로
        maxWidth: MAX_WIDTH, // 이미지 최대 너비
        maxHeight: MAX_HEIGHT, // 이미지 최대 높이
        compressQuality: COMPRESS_QUALITY // 이미지 압축 품질
    );
    
    if(croppedImage != null) {            
      late File imageTaken;
      changeFileNameOnly(File(croppedImage.path), 'mPhoto$index.jpg')
      .then((value) {
        imageTaken=value;
        setState(() {
          if(index==1) mPhoto1 = imageTaken;
          if(index==2) mPhoto2 = imageTaken;
          if(index==3) mPhoto3 = imageTaken;        
        });
      });      
    } else {
      print('error😣😣😣');
    }
}

Future<File> changeFileNameOnly(File file, String newFileName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.rename(newPath);
}

  Future<String> uploadWithImages({required String mId, required String qTitle, required String qContent}) async {
    _images.clear();

   if (mPhoto1 != null) {
      setState(() {        
        _images.add(mPhoto1!.path);    
      });
    } if (mPhoto2 != null) {      
      setState(() {
        _images.add(mPhoto2!.path);        
      });
    } if (mPhoto3 != null) {      
      setState(() {
        _images.add(mPhoto3!.path);
      });
    }    
    print(_images);
    AccessToDB accessToDB = AccessToDB();
    var response = await accessToDB.writeQnA(paths: _images, mId: _mId, qTitle: _qTitle, qContent: _qContent);
    print('uploadWithImages: $response');

    return response;
  }

  

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: serviceAppbar),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 10)),
                _QnAWriteForm(),
                SizedBox(height: defaultPadding,),              
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(child: photoAdded(mPhoto1, 1)),
                      Expanded(child: photoAdded(mPhoto2, 2)),
                      Expanded(child: photoAdded(mPhoto3, 3)),                      
                    ],
                  ),
                ),                
                SizedBox(height: defaultPadding),
                Text('*사진은 3장까지 등록 가능합니다.', style: TextStyle(color: Colors.red),),
                SizedBox(height: defaultPadding),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [                    
                    SizedBox(                          
                      child: ElevatedButton(
                        child: Text('취소'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {Navigator.pop(context);},
                        ),
                    ),
                    SizedBox(width: defaultPadding,),                    
                    ElevatedButton(
                      onPressed: () async {                          
                        if (_formKey.currentState!.validate())  {
                          _formKey.currentState!.save();  

                          uploadWithImages(mId: _mId, qTitle: _qTitle, qContent: _qContent)
                          .then((value) {
                              
                            var json = jsonDecode(value);
                            
                            ShowAlertDialog showAlertDialog = ShowAlertDialog();
          
                            if( json['code']=='success'){
                              showAlertDialog
                                .showMyDialog(context: context, 
                                              title: "등록 성공😁", 
                                              message: json['desc'],
                                              nSort: toQnAMainPage,
                                              mId: _mId
                                              );
                            } else {
                              showAlertDialog
                                .showMyDialog(context: context, 
                                              title: "등록 실패😥", 
                                              message: json['desc'],                                                  
                                              );
                            }
                          });
                        }
                      },
                      child: Text("등록"),
                    ),                        
                  ],
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getAPrimary(bool checkPrimay) {
    int result = 0;
    
    if(checkPrimay){
      result=1;
    }

    return result;
  }

  Widget _QnAWriteForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('제목'),
              SizedBox(width: defaultPadding,),
              Expanded(
                child: SizedBox(
                  child: TextFormField(                    
                    textAlign: TextAlign.center,
                    onSaved: (qTitle) => _qTitle = qTitle!,
                    validator: RequiredValidator(errorText: '제목을 입력하세요.'),
                  ),
                ),
              ),  
            ],
          ),
          SizedBox(height: defaultPadding,),
          Text('내용'),          
          SizedBox(height: defaultPadding,),          
          Container(            
            child: TextFormField(
              maxLength: 300,
              maxLines: 10,
              decoration:  const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                //labelText: '내용 입력',
                //counterText: "", // maxLength 를 감춘다.
                counterStyle: TextStyle(
                                fontSize:  20.0,
                                color: Colors.red,
                              ),
              ),
              onSaved: (qContent) => _qContent = qContent ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _childPopupWithPhoto(Widget child, int index) => PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: () {
                    deleteExPhoto(index);
                    takePhoto(ImageSource.gallery, index);
                  },
                  child: Text(
                    "앨범",
                    style: TextStyle(
                        color: TEXT_BLACK, fontWeight: FontWeight.w700),
                  ),
                ),
                PopupMenuItem(                  
                  value: 2,
                  onTap: () {
                    deleteExPhoto(index);
                    takePhoto(ImageSource.camera, index);
                  },
                  child: Text(
                    "카메라",
                    style: TextStyle(
                        color: TEXT_BLACK, fontWeight: FontWeight.w700),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  onTap: () {
                    deleteExPhoto(index);                    
                  },
                  child: Text(
                    "삭제",
                    style: TextStyle(
                        color: TEXT_BLACK, fontWeight: FontWeight.w700),
                  ),
                ),                
              ],
          // offset: Offset(0, 0), // 팝업 위치 조정 - (x, y) 기본 값은 (0, 0)
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),          
        );
  
  Widget _childPopupWithoutPhoto(Widget child, int index) => PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: () => takePhoto(ImageSource.gallery, index),
                  child: Text(
                    "앨범",
                    style: TextStyle(
                        color: TEXT_BLACK, fontWeight: FontWeight.w700),
                  ),
                ),
                PopupMenuItem(                  
                  value: 2,
                  onTap: () => takePhoto(ImageSource.camera, index),
                  child: Text(
                    "카메라",
                    style: TextStyle(
                        color: TEXT_BLACK, fontWeight: FontWeight.w700),
                  ),
                ),                
              ],
          // offset: Offset(0, 0), // 팝업 위치 조정 - (x, y) 기본 값은 (0, 0)
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),          
        );
   
  
  Widget photoAdded(File? mPhoto, int index) {
    late Widget buttonChild;    
    if(mPhoto != null) {            
      buttonChild = Image.file(
              mPhoto,
              fit: BoxFit.contain,
            );      
      return Container(
                  child: _childPopupWithPhoto(buttonChild, index),
                );
    } else {
      buttonChild = Text('사진추가📸', style: TextStyle(color: Colors.blue),);
      return Container(
                  child: _childPopupWithoutPhoto(buttonChild, index),
                );
    }    
  }
}