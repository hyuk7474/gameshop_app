import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';


class ModifyAddressPage extends StatefulWidget {
  late AddressInfo aInfo;

  ModifyAddressPage({Key? key, required this.aInfo}) : super(key: key);

  @override
  State<ModifyAddressPage> createState() => _ModifyAddressPageState();
}

class _ModifyAddressPageState extends State<ModifyAddressPage> {

  GetAppBar getAppBar = GetAppBar();

    
  TextEditingController _aZipcodeCtrl = TextEditingController();
  TextEditingController _aMainCtrl = TextEditingController();     
  
  void setInfo() {
    setState(() {
      _aZipcodeCtrl.text = widget.aInfo.aZipcode;
      _aMainCtrl.text = widget.aInfo.aMain;
      if(widget.aInfo.aPrimary==1){
        _checkPrimary = true;
      }
      
    });
    
    
  }

  late String _mId, _aName, _aZipcode, _aMain, _aSub;

  bool _checkPrimary = false;

  late SharedPreferences prefs;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();    
    _mId = prefs.getString('mId') ?? 'id is not loaded';
  }

  @override
  void initState() {
    getSharedPreferences();
    setInfo();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: orderAppbar),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 10)),
                  AddressText(),
                  SizedBox(height: defaultPadding,),
                  Row(
                    children: [
                      Text('주요 배송지로 설정'),
                      Checkbox(
                            value: _checkPrimary, 
                            onChanged: (value) {
                              setState(() {
                                _checkPrimary = value!;
                              });
                              print(_checkPrimary);
                            }),
                    ],
                  ),
                      SizedBox(width: defaultPadding,),
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
                      
                      SizedBox(                          
                        child: ElevatedButton(
                          onPressed: () async {                          
                            if (_formKey.currentState!.validate())  {
                              _formKey.currentState!.save();                              
                              

                              print(getAPrimary(_checkPrimary));

                              print("$_mId / $_aName / $_aZipcode / $_aMain / $_aSub");

                              AccessToDB accessToDB = AccessToDB();
                              accessToDB.modifyAdress(
                                mId: _mId,
                                oriName: widget.aInfo.aName,
                                aName: _aName,                                
                                aZipcode: _aZipcode, 
                                aMain: _aMain, 
                                aSub: _aSub,
                                aPrimary: getAPrimary(_checkPrimary).toString(),
                              ).then((value) {
                                  
                                var json = jsonDecode(value);
                                
                                ShowAlertDialog showAlertDialog = ShowAlertDialog();

                                if( json['code']=='success'){
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "수정 성공😁", 
                                                  message: json['desc'],
                                                  nSort: toAddressMainPage,
                                                  mId: _mId
                                                  );
                                } else {
                                  showAlertDialog
                                    .showMyDialog(context: context, 
                                                  title: "수정 실패😥", 
                                                  message: json['desc'],                                                  
                                                  );
                                }
                              });
                            }
                          },
                          child: Text("수정"),
                        ),
                      ),                        
                    ],
                  ), 
                ],
              ),
            ],
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

  Widget AddressText() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('배송지 명'),
              SizedBox(
                width: 130,
                child: TextFormField(
                  initialValue: widget.aInfo.aName,
                  // controller: _NameCtrl,
                  textAlign: TextAlign.center,
                  onSaved: (aName) => _aName = aName!,
                  validator: RequiredValidator(errorText: '배송지 명을 입력하세요.'),
                ),
              ),  
            ],
          ),
          SizedBox(height: defaultPadding,),
          Text('주소'),
          Row(
            children: [       
              SizedBox(
                width: 80,
                child: TextFormField(         
                  // initialValue: widget.aInfo.aZipcode,     
                  controller: _aZipcodeCtrl,  
                  enabled: false,                                
                  textAlign: TextAlign.center,
                  onSaved: (aZipcode) => _aZipcode = aZipcode!,
                ),
              ),                          
              SizedBox(width: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _addressAPI(); // 카카오 주소 API
                }, 
                child: Text('주소 찾기')),
            ],
          ),
          SizedBox(height: defaultPadding,),
          TextFormField(
            // initialValue: widget.aInfo.aMain,
            controller: _aMainCtrl,  
            enabled: false,                      
            onSaved: (aMain) => _aMain = aMain!,
          ),
          SizedBox(height: defaultPadding,),
          TextFormField(
            initialValue: widget.aInfo.aSub,            
            decoration: InputDecoration(hintText: "상세 주소 입력"),            
            onSaved: (aSub) => _aSub = aSub ?? '',
          ),
        ],
      ),
    );
  }

  _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    print('${model.zonecode!} / ${model.address!} / ${model.buildingName!}');
    _aMainCtrl.text =
        '${model.address!} ${model.buildingName!}';
    _aZipcodeCtrl.text = model.zonecode!;
  }
}