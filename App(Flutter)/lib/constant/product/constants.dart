import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/member/constants.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/pages/actiongame/order/order_process.dart';

const orderProcessLargeFont = 25.0;
const orderProcessMiddleFont = 17.0;

const detailPriceWeight = FontWeight.w200;
const totalPriceWeight = FontWeight.w900;

const Color pInfoBorderColor = Colors.green;

String title = 'Grand Theft Auto V';
String price = '30000';
String story = '모든 일의 시작이 되는, 본편 시점인 2013년의 9년 전인 2004년, 3인조 강도단이었던 마이클 타운리와 트레버 필립스, 브래드 스나이더는 북부 양크턴 주 루덴도르프의 한 은행을 성공적으로 털고, 도주차량을 통해 헬리콥터 착륙지점에 가려 한다. 하지만 경찰에게서 도망치던 중 철 ';
String imgurl = 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5.jpg?alt=media&token=02099b3c-73a8-4122-9774-c3824ed6e342';
String imgurl1 = 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5%2Fgta5-1.jpg?alt=media&token=7be71ad7-3917-42f9-ad2d-4060238b709b';
String imgurl2 = 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5%2Fgta5-2.jpg?alt=media&token=a1183d4f-6498-4412-b71c-0ebca6aba39c';
String imgurl3 = 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5%2Fgta5-3.jpg?alt=media&token=29744d07-d981-454d-8d22-40164b5ddecb';

DetailInfo tempPInfo = DetailInfo(title: title, price: price, story: story, imgurl: imgurl, imgurl1: imgurl1, imgurl2: imgurl2, imgurl3: imgurl3, ex: 'ex', spec: 'spec');

DetailInfo dbPInfo1 = DetailInfo(
  title: '닌텐도 스위치 스플래툰 3', 
  price: '59800', 
  story: '모든 일의 시작이 되는, 본편 시점인 2013년의 9년 전인 2004년, 3인조 강도단이었던 마이클 타운리와 트레버 필립스, 브래드 스나이더는 북부 양크턴 주 루덴도르프의 한 은행을 성공적으로 털고, 도주차량을 통해 헬리콥터 착륙지점에 가려 한다. 하지만 경찰에게서 도망치던 중 철 ', 
  cId: '1030',
  imgurl: '$serverAddress/upload/ae93cd8e13ad41b0983c8c2e06f0f7e1.LM4902370550696_001_1.jpg', 
  imgurl1: '$serverAddress/upload/splatoon3_1.jfif',
  imgurl2: '$serverAddress/upload/images_splatoon3.jfif', 
  imgurl3:  '$serverAddress/upload/e49c21726407465dbc13ad5222b9b9b2.20220722090536685.jpg', 
  ex: '$serverAddress/upload/e49c21726407465dbc13ad5222b9b9b2.20220722090536685.jpg', 
  spec: '$serverAddress/upload/e49c21726407465dbc13ad5222b9b9b2.20220722090536685.jpg', );

DetailInfo dbPInfo2 = DetailInfo(
  title: '스위치 별의 커비 디스커버리', 
  price: '54800', 
  story: '모든 일의 시작이 되는, 본편 시점인 2013년의 9년 전인 2004년, 3인조 강도단이었던 마이클 타운리와 트레버 필립스, 브래드 스나이더는 북부 양크턴 주 루덴도르프의 한 은행을 성공적으로 털고, 도주차량을 통해 헬리콥터 착륙지점에 가려 한다. 하지만 경찰에게서 도망치던 중 철 ', 
  cId: '1040', 
  imgurl: '$serverAddress/upload/ccdb625922ba40a8be70af34b850ec3d.LM4902370549539_001_1.jpg', 
  imgurl1: '$serverAddress/upload/b4013671000f7732f554a1483bd1c7ba_kirby1.jpg', 
  imgurl2: '$serverAddress/upload/ccdb625922ba40a8be70af34b850ec3d.LM4902370549539_001_1.jpg', 
  imgurl3: '$serverAddress/upload/images_kirby.jfif', 
  ex: '$serverAddress/upload/ccdb625922ba40a8be70af34b850ec3d.LM4902370549539_001_1.jpg', 
  spec: '$serverAddress/upload/b4013671000f7732f554a1483bd1c7ba_kirby1.jpg',
);

// DetailInfo dbPInfo3 = DetailInfo(
//   title: '', 
//   price: '', 
//   story: '', 
//   imgurl: '$serverAddress/upload/ae93cd8e13ad41b0983c8c2e06f0f7e1.LM4902370550696_001_1.jpg', 
//   imgurl1: '$serverAddress/upload', 
//   imgurl2: '$serverAddress/upload', 
//   imgurl3: '$serverAddress/upload', 
//   ex: '$serverAddress/upload', 
//   spec: '$serverAddress/upload');







const List<String> selectDeliveryText = [  
  '배송메모를 선택해 주세요.',
  '요청사항을 직접 입력합니다.',
  '배송 전에 미리 연락 바랍니다.',
  '부재시 경비실에 맡겨 주세요.',
  '부재시 전화 주거나 문자 남겨 주세요.',
];