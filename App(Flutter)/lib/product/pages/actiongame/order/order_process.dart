import 'dart:convert';

import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/constant/product/constants.dart';
import 'package:shopping_ui/member/access_to_db/access_to_db.dart';
import 'package:shopping_ui/member/components/appbar.dart';
import 'package:shopping_ui/member/mypage/manage_address/components/address_info.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/pages/actiongame/components/order_components.dart';
import 'package:shopping_ui/widgets/alert_dialog.dart';



class OrderProcess extends StatefulWidget {
  
  late DetailInfo pInfo;
  late int qty;

  List<AddressInfo>? addressList = [];
  late String? mId;

  OrderProcess({Key? key, this.addressList, this.mId, required this.pInfo, required this.qty}) : super(key: key);

  @override
  State<OrderProcess> createState() => _OrderProcessState();
}

class _OrderProcessState extends State<OrderProcess> {

  GetAppBar getAppBar = GetAppBar();

  ShowAlertDialog showAlertDialog = ShowAlertDialog();
  AccessToDB accessToDB = AccessToDB();

  late String title = widget.pInfo.title;
  late double price = double.parse(widget.pInfo.price);

  late int counter = widget.qty;
  num deliveryPrice = 3000;  
  
  TextEditingController _NameCtrl = TextEditingController();
  TextEditingController _ZipcodeCtrl = TextEditingController();
  TextEditingController _aMainCtrl = TextEditingController();
  TextEditingController _aSubCtrl = TextEditingController();

  late String _aName, _aZipcode, _aMain, _aSub;
  
  late String _mId = widget.mId!;

  Color _selBackColor =  Colors.white;
  Color _selBottomColor =   Colors.white;
  Color _addBackColor =  Color.fromARGB(255, 201, 201, 201);
  Color _addBottomColor = Colors.black;

  

  // 가져운 정보
  late String selAName, selAZipcode, selAMain;
  late String? selASub;

  String _deliveryText = '배송메모를 선택해 주세요.';

  bool _checkPrimary = false;
  bool _checkAddAddress = false;
  
  bool _checkAInfoValid = true;
  
  bool _chooseAddres = false;  
  bool _selectedAddress = true;

  String _chosenText = '배송메모를 선택해 주세요.';
  bool _inputDeliveryText = false;

  late SharedPreferences prefs;

  final GlobalKey<FormState> _addAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _orderInfoFormKey = GlobalKey<FormState>();



  bool showAInfo = true;
  
  AddressInfo pAddress = AddressInfo.empty();
  

  Color color =  Color.fromARGB(255, 165, 214, 167);


  void setPrimary() {    
    if(widget.addressList!.isNotEmpty){
      pAddress=widget.addressList![0];
      selAName = pAddress.aName;
      selAMain = pAddress.aMain;
      selASub = pAddress.aSub ?? '';
      selAZipcode = pAddress.aZipcode;
    } else {
      _checkAInfoValid=false;
      selAName = '';
      selAMain = '';
      selASub = '';
      selAZipcode = '';
    }
    
  }

  //-----------------------결제 관련 메소드 및 변수 시작-----------------------------

  String webApplicationId = ''; // secret key
  String androidApplicationId = '';  // secret key
  String iosApplicationId = '';  // secret key

  void bootpay(BuildContext context) {

    Payload payload = getPayload();
    if(kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('Confirmed');
        accessToDB.addPaidInfo(mId: _mId, pcid: '25', pcount: counter.toString(), paddress: '$selAMain $selASub ($selAZipcode)', pdeliverymemo: _deliveryText, paid: (price*counter+deliveryPrice).toString())
        .then((value) {
          showAlertDialog.showMyDialog(context: context, title: title, message: '주문이 완료되었습니다.', nSort: toOrderResultPage, mId: _mId);
        },);
        
        
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
        showAlertDialog.showMyDialog(context: context, title: title, message: 'Done');
      },
    );
  }

  Payload getPayload() {
    Payload payload = Payload();
    
    Item deliveryFee = Item();
    deliveryFee.name = '배송비'; // 주문정보에 담길 상품명
    deliveryFee.qty = 1; // 해당 상품의 주문 수량
    deliveryFee.id = "DELIVERY_FEE"; // 해당 상품의 고유 키
    deliveryFee.price = deliveryPrice.toDouble(); // 상품의 가격
    
    Item item = Item();
    item.name = title; // 주문정보에 담길 상품명
    item.qty = counter; // 해당 상품의 주문 수량
    item.id = "ITEM_CODE_SWITCHGAME"; // 해당 상품의 고유 키
    item.price = price; // 상품의 가격

    List<Item> itemList = [item, deliveryFee];    

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    // payload.pg = '나이스페이';
    // payload.method = '카드';
    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.orderName = item.name; //결제할 상품명
    payload.price = price*counter+deliveryPrice; //정기결제시 0 혹은 주석


    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함


    // 해당 데이터 사용 X, Bootpay 로직상 존재
    payload.metadata = {
      "callbackParam1" : "value12",
      "callbackParam2" : "value34",
      "callbackParam3" : "value56",
      "callbackParam4" : "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'GameShopPay';
    extra.cardQuota = '3';
    
    payload.user = user;
    payload.extra = extra;
    return payload;
  }

  //-----------------------결제 관련 메소드 및 변수 끝-----------------------------
  

  @override
  void initState() {    
    setPrimary();        
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar.returnAppBar(which: orderAppbar),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
              Container(height: defaultPadding,),
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: _selBackColor,
                        child: Container(              
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: _selBottomColor,
                                width: qnaBoardLine,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                              bottom: BorderSide(
                                  color:_selBottomColor,
                                  width: qnaBoardLine,
                                ),
                            ),
                          ),              
                          height: 50,                        
                          child: TextButton(                                                   
                            onPressed: () {
                              toSelVisible();
                              _selBackColor = Colors.white;
                              _selBottomColor = Colors.white;
                              _addBackColor = Color.fromARGB(255, 201, 201, 201);
                              _addBottomColor = Colors.black;
                            },
                            child: const Text(
                              "배송지 선택",
                              style: TextStyle(fontSize: orderProcessMiddleFont, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),                    
                    Expanded(
                      child: Container(
                        color: _addBackColor,
                        child: Container(                              
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                              left: BorderSide(
                                color: _addBottomColor,
                                width: qnaBoardLine,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                              bottom: BorderSide(
                                color:_addBottomColor,
                                width: qnaBoardLine,
                              ),
                            ),
                          ),              
                          height: 50,                        
                          child: TextButton(                              
                            onPressed: () {
                              toAddVisible();
                              _selBackColor = Color.fromARGB(255, 201, 201, 201);
                              _selBottomColor = Colors.black;
                              _addBackColor = Colors.white;
                              _addBottomColor = Colors.white;
                            },
                            child: const Text(
                              "배송지 추가",
                              style: TextStyle(fontSize: orderProcessMiddleFont, color: Colors.black),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,                                
                decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),                              
                              bottom: BorderSide(
                                color: Colors.black,
                                width: qnaBoardLine,
                              ),
                            ),
                          ),  
                child: getAddressWidget(),
              ),
              SizedBox(height: defaultPadding,),
              LineToSeperate(),
              TitleWidget(text: '배송메모'),   
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [              
                    DropdownButton <String>(              
                    value:  _chosenText,
                    items: selectDeliveryText.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint:const Text('부재시 전화 주거나 문자 남겨 주세요.',),
                    onChanged: (String? value) {
                      print(value);
                      setState(() {
                        _chosenText = value!;
                        if(value=='요청사항을 직접 입력합니다.') _inputDeliveryText=true;
                        else {
                          _inputDeliveryText=false;
                          _deliveryText = value;
                        }
                      });                
                    },                    
                  ),
                  ]
                )
              ),
              Visibility(
                visible: _inputDeliveryText,
                child: Form(
                  key: _orderInfoFormKey,
                  child: TextFormField(
                    maxLength: 300,
                    maxLines: 3,
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
                    onSaved: (deliveryText) => _deliveryText = deliveryText ?? '',
                    onChanged: (deliveryText) => _deliveryText = deliveryText,
                  ),
                )
              ),
              LineToSeperate(),
              TitleWidget(text: '주문 상품'),
              Container(
                width: double.infinity,                
                child: Row(
                  children: [
                    Expanded(                    
                      flex: 2,
                      child: Container(                                                                    
                        child: Image.network(widget.pInfo.imgurl),
                        // Image(image: AssetImage("assets/images/temp/kirby.jpg"))
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          children: [
                            Text(title),
                            Text('${getPriceString(price)} 원', textAlign: TextAlign.center,),                          
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [                                                                              
                            SizedBox(
                              
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.plusCircle, color: Colors.black,),
                                onPressed: () {
                                  _incrementCounter();
                                },
                              ),
                            ),
                            Text(returnCounter(counter).toString()),
                            SizedBox(                            
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.black,),
                                onPressed: () {
                                  _decrementCounter();
                                },
                              ),
                            ),
                          
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
              LineToSeperate(),
              TitleWidget(text: '결제 상세'),
              SizedBox(height: defaultPadding,),
              Container(                
                width: double.infinity,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [                    
                    Expanded(                      
                      child: Container(                        
                        child: Column(       
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('주문금액', style: TextStyle(fontSize: orderProcessMiddleFont-2, fontWeight: totalPriceWeight)),
                            Text('배송비', style: TextStyle(fontWeight: detailPriceWeight),),
                            Text('상품금액', style: TextStyle(fontWeight: detailPriceWeight),),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: Container(),),                    
                    Expanded(                      
                      child: Container(                        
                        child: Column(       
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [                            
                            Text('${getPriceString(price*counter+deliveryPrice)} 원', style: TextStyle(fontSize: orderProcessMiddleFont-2, fontWeight: totalPriceWeight),),
                            Text('3,000 원', style: TextStyle(fontWeight: detailPriceWeight),),                           
                            Text('${getPriceString(price*counter)} 원', style: TextStyle(fontWeight: detailPriceWeight),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),              
              Container(
                width: double.infinity,                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: Text('취소'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                    SizedBox(width: defaultPadding,),
                    ElevatedButton(
                      onPressed: () {

                        print('$selAName / $selAMain / $selASub / $selAZipcode');

                        if(_deliveryText=='배송메모를 선택해 주세요.'){
                          ShowAlertDialog showAlertDialog = ShowAlertDialog();
                          showAlertDialog.showMyDialog(context: context, title: '😣', message: _deliveryText);
                          return;
                        }

                        if(selAName==''||selAMain==''||selAZipcode==''){
                          if (_addAddressFormKey.currentState!.validate()) {
                            _addAddressFormKey.currentState!.save(); 
                          } else {
                            ShowAlertDialog showAlertDialog = ShowAlertDialog();
                            showAlertDialog.showMyDialog(context: context, title: '😣', message: '주소를 입력해주세요.');
                            return;                          
                          }
                          
                        }
                        
                        print(_deliveryText);

                        // if (_orderInfoFormKey.currentState!.validate()){                          
                        //   _orderInfoFormKey.currentState!.save();
                        // }

                        if(_checkAddAddress) {                          
                          _addAddress(); // 주소 추가 메소드
                        }

                        bootpay(context);
                      }, 
                      child: Text('주문')
                    ),
                    SizedBox(height: defaultPadding,),
                  ],
                ),
              )
            ],
          ),        
        ),
      ),
    );
  }

  int returnCounter(int num) {    
    int result = num;
    if(num < 1) {      
      setState(() {        
        counter = 1;        
      });         
      result = 1;   
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



  String getPriceString(num num) {    
    String result = num.toString();

    int iCheck = result.indexOf('.');

    if(iCheck>-1) result = result.substring(0, iCheck);
    print(result);
    if(result.length>3) {
      int restStr = result.length % 3;
      if(restStr == 0) {
        result = plusComma(result, 0);
        // int iDivided = result.length ~/ 3;
        // for(int i=0; i<iDivided-1;i++) {
        //   String temp = '';
        //   temp = '${result.substring(i*3,i*3+3)},';
        //   result = result + temp;
        // }        
        // result = result.substring(0,result.length-1);
      } else if(restStr == 1) {
        result = plusComma(result, 1);
        
      } else if(restStr == 2) {
        result = plusComma(result, 2);
        
      }
    }    
    return result;
  }

  void _decrementCounter() {
    setState(() {
      counter--;
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }
  
  Widget getAddressWidget() {    
    if(showAInfo){
      if(_checkAInfoValid) {
        return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(                
                width: double.infinity,
                child: 
                  Column(
                    children: [
                      Visibility(
                        visible: _selectedAddress,
                        child: Container(                          
                          width: double.infinity,
                          child: Card(                        
                            color: Colors.lightGreen[100],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(                                                                    
                                      child: Column(                              
                                        children: [                                        
                                          Text('$selAName\n$selAMain\n${selASub}\n($selAZipcode)'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(                                      
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(                                        
                                          child: ElevatedButton(
                                            child: Text('변경'),
                                            onPressed: () {
                                              changeAddressWidget();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),                        
                      Visibility(
                        visible: _chooseAddres,
                        child: Column(
                          children: [                            
                            Container(
                              width: double.infinity,
                              child: cardList(widget.addressList!, _mId)
                              // CardList(addressList: widget.addressList!, mId: _mId)
                            )                            
                          ],
                        ))
                    ],                      
                  )
              ),
            );
      } else {
        return Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("저장된 배송지가 없습니다.\n 배송지를 추가해주세요.", style: TextStyle(fontSize: orderProcessMiddleFont),),
        ));
      }
      
    } else if(!showAInfo){
      return AddAddressForm();
    }
      
       
    return CircularProgressIndicator();
    
  }

  Widget cardList(List<AddressInfo> addressList, String mId) {
    return Container(
            width:  double.infinity,
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.vertical,                
              itemCount: addressList.length,
              itemBuilder: (BuildContext context, int index){
                return personTile(addressList[index], index, mId);
              }
            ),
          );
  }

  Widget personTile(AddressInfo aInfo, int index, String _mId) {
    // print(aInfo.aName);
    return  Card(
      color: Colors.lightGreen[100],      
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(                                                  
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    
                    Text(
                      "${aInfo.aName}\n${aInfo.aMain}\n${aInfo.aSub ?? ""}(${aInfo.aZipcode})"),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(                
                child: Align(
                  alignment: Alignment.center,
                  child: Container(                                        
                    child: ElevatedButton(
                      child: Text('선택'),
                      onPressed: () {      
                        changeAddressWidget();
                        setState(() {
                          selAName=aInfo.aName;
                          selAZipcode=aInfo.aZipcode;
                          selAMain=aInfo.aMain;
                          selASub=aInfo.aSub ?? '';
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),         
    );

  }


  void changeAddressWidget() {    
    if(_chooseAddres) {
      _chooseAddres = false;
      _selectedAddress = true;
    } else {
      _chooseAddres = true;
      _selectedAddress = false;
    }
    setState(() {
      _chooseAddres;
      _selectedAddress;
    });    
  }

  

  void toSelVisible() {
    setState(() {      
     showAInfo = true;

      color = Color.fromARGB(255, 200, 230, 201);
    });
  }

  void toAddVisible() {   
    
      setState(() {

      showAInfo = false;
  
      color = Color.fromARGB(255, 248, 229, 171);
    });
    
  }

  int getAPrimary(bool checkPrimay) {
    int result = 0;
    
    if(checkPrimay){
      result=1;
    }

    return result;
  }

  Widget AddAddressForm() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Form(
        key: _addAddressFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('배송지 명'),
                SizedBox(
                  width: 130,
                  child: TextFormField(
                    controller: _NameCtrl,
                    textAlign: TextAlign.center,
                    onSaved: (aName) => _aName = aName!,
                    onChanged:(value) => selAName=value,
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
                    enabled: false,              
                    controller: _ZipcodeCtrl,
                    textAlign: TextAlign.center,
                    onSaved: (aZipcode) {
                      _aZipcode = aZipcode!;
                      selAZipcode = aZipcode;
                    },
                    onChanged: (value) => selAZipcode = value,
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
              enabled: false,          
              controller: _aMainCtrl,
              onSaved: (aMain) {
                _aMain = aMain!;
                selAMain = aMain;
              },
              onChanged: (value) => selAMain = value,
            ),
            SizedBox(height: defaultPadding,),
            TextFormField(
              decoration: InputDecoration(hintText: "상세 주소 입력"),
              controller: _aSubCtrl,
              onSaved: (aSub) => _aSub = aSub ?? '',
              onChanged: (value) => selASub = value,
            ),
            SizedBox(height: defaultPadding,),
            Row(
              children: [            
                Checkbox(
                  value: _checkAddAddress, 
                  onChanged: (value) {
                    setState(() {
                      _checkAddAddress = value!;
                    });
                    print(_checkPrimary);
                  }),
                Text('배송지 목록에 추가'),
              ],
            ),
            SizedBox(width: defaultPadding,),
            Row(
              children: [            
                Checkbox(
                  value: _checkPrimary, 
                  onChanged: (value) {
                    setState(() {
                      _checkPrimary = value!;
                    });
                    print(_checkPrimary);
                  }),
                Text('기본 배송지로 설정'),
              ],
            ),                        
          ],
        ),
      ),
    );
  }

  _addAddress() {
    if (_addAddressFormKey.currentState!.validate())  {
      _addAddressFormKey.currentState!.save();                              
      

      print(getAPrimary(_checkPrimary));

      print("$_mId / $_aName / $_aZipcode / $_aMain / $_aSub");

      AccessToDB accessToDB = AccessToDB();
      accessToDB.addAdress(
        mId: _mId,
        aName: _aName,
        aZipcode: _aZipcode, 
        aMain: _aMain, 
        aSub: _aSub,
        aPrimary: getAPrimary(_checkPrimary).toString(),
      ).then((value) {
          
        var json = jsonDecode(value);
        
        ShowAlertDialog showAlertDialog = ShowAlertDialog();

        if( json['code']=='success'){
          print('Add Succeed');
        } else {
          print('Add Failed');
        }
      });
    }
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
    _ZipcodeCtrl.text = model.zonecode!;
  }
}