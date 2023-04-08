import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_ui/constant/member/constants.dart';

class AccessToDB {
  late String responseBody;

  void printResult(http.Response response) {
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    responseBody = utf8.decode(response.bodyBytes);
    print("statusCode: $statusCode");
    // print("responseHeaders: $responseHeaders");
    print("responseBody: $responseBody");
    var json = jsonDecode(responseBody);
    print("json[code]: ${json['code']}");
    print("json[desc]: ${json['desc']}");
  }

  Future<String> doJoin({String? mEmail, String? mPnum, required String mId, required String mPw, required String mName}) async {
    var url = Uri.parse("$appAddress/join");    
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,
        'mPw': mPw, 
        'mName': mName, 
        'mEmail': mEmail ?? '',
        'mPnum': mPnum ?? '',
      },
    );

    printResult(response);

    return responseBody;
  }

  doLogin({required String mId}) async {
    var url = Uri.parse("$appAddress/login");
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,        
      },
    );

    printResult(response);

    return responseBody;
  }

  modifyMInfo({String? mEmail, String? mPnum, required String mId, required String mName}) async {
    var url = Uri.parse("$appAddress/modify");    
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,        
        'mName': mName, 
        'mEmail': mEmail,
        'mPnum': mPnum,
      },
    );

    printResult(response);


    return responseBody;
  }

  modifyPW({required String mPw, required String mId}) async {
    var url = Uri.parse("$appAddress/modifyPw");    
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,                
        'mPw': mPw,
      },
    );

    printResult(response);


    return responseBody;
  }

  Future<String> addAdress({required String? mId, required String? aName, required String aZipcode, required String aMain, required String aSub, required String aPrimary}) async {
    var url = Uri.parse("$addressAddress/addAdress");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,
        'aName': aName, 
        'aZipcode': aZipcode, 
        'aMain': aMain,
        'aSub': aSub,
        'aPrimary': aPrimary,
      },
    );

    printResult(response);
        
    return responseBody;
  }

  Future<String> getAdressList({required String? mId}) async {
    var url = Uri.parse("$addressAddress/getList");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,        
      },
    );

    printResult(response);
        
    return responseBody;
  }

  Future<String> deleteAdress({required String mId, required String aName}) async {
    var url = Uri.parse("$addressAddress/delete");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,
        'aName': aName,
      },
    );

    printResult(response);
        
    return responseBody;
  }

  Future<String> modifyAdress({required String? mId, required String? oriName, required String? aName, required String aZipcode, required String aMain, required String aSub, required String aPrimary}) async {
    var url = Uri.parse("$addressAddress/modify");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,
        'oriName': oriName,
        'aName': aName, 
        'aZipcode': aZipcode, 
        'aMain': aMain,
        'aSub': aSub,
        'aPrimary': aPrimary,
      },
    );

    printResult(response);
        
    return responseBody;
  }  

  Future<String> getQnAList({required String? mId}) async {    
    var url = Uri.parse("$serviceAddress/getList");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'mId': mId,        
      },
    );

    printResult(response);
        
    return responseBody;
  }
  
  Future<String> writeQnA({required List<String> paths, required String mId, required String qTitle, required String qContent}) async {
    Uri uri = Uri.parse('$serviceAddress/write');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
    ..fields['mId'] = mId
    ..fields['qTitle'] = qTitle
    ..fields['qContent'] = qContent;
    
    for(String path in paths){          
      request.files.add(await http.MultipartFile.fromPath('files', path));
    }    

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);    
    print('RESPONSE WITH HTTP');
    print(responseString);
        
    return responseString;
  }

  Future<String> deleteQnA({required String qId}) async {    
    var url = Uri.parse("$serviceAddress/delete");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'qId': qId,
      },
    );

    printResult(response);
        
    return responseBody;
  }  

  Future<String> modifyQnA({required List<String> paths, required String qTitle, required String qContent, required String qId}) async {
    Uri uri = Uri.parse('$serviceAddress/modify');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)    
    ..fields['qTitle'] = qTitle
    ..fields['qContent'] = qContent
    ..fields['qId'] = qId;
    
    for(String path in paths){          
      request.files.add(await http.MultipartFile.fromPath('files', path));
    }    

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);    
    print('RESPONSE WITH HTTP');
    print(responseString);
        
    return responseString;
  }

  Future<String> getModifiedQnA({required String qId}) async {    
    var url = Uri.parse("$serviceAddress/getModified");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {        
        'qId': qId,
      },
    );

    printResult(response);
        
    return responseBody;
  }
  
  Future<String> addPaidInfo({required String? mId, required String pcid, required String pcount, required String paddress, required String pdeliverymemo, required String paid}) async {
    var url = Uri.parse("$appAddress/product/addPaidInfo");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {                
        'mId': mId, 
        'pcid': pcid, 
        'pcount': pcount,
        'paddress': paddress,
        'pdeliverymemo': pdeliverymemo,
        'paid' : paid,
      },
    );

    printResult(response);
        
    return responseBody;
  }

  Future<String> getPaidInfo({required String? mId}) async {
    var url = Uri.parse("$appAddress/product/getPaidList");        
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
      },
      body: {                
        'mId': mId,         
      },
    );

    printResult(response);
        
    return responseBody;
  }


}