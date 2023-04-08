import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const ipAddress = '192.168.0.26';
const serverAddress = 'http://$ipAddress:8081';
const appAddress = '$serverAddress/app';
const addressAddress = '$appAddress/address';
const serviceAddress = '$appAddress/service';

const String naver = '(n)';
const String kakao = '(k)';
const String google = '(gg)';
const String facebook = '(fb)';

const toMainPage = 0;
const toLoginPage = 1;
const toModifyPage = 2;
const toMyPage = 3;
const toAddressPage =4;
const toAddressMainPage = 5;
const toQnAMainPage = 6;
const toModifiedQnAPage = 7;
const toOrderResultPage = 8;

const installKakao = 21;
const installNaver = 22;

const qnaBoardLine = 2.0;

const titleTextSize = 24.0;
const subTitleTextSize = 20.0;

const qContentHeight = 300.0;
const qnaListTileHeight = 60.0;
const qnaViewTileHeight = 60.0;

const memberInfoAppbar = 1;
const orderAppbar = 2;
const serviceAppbar = 3;

const primaryColor = Color(0xFF255ED6);
const textColor = Color(0xFF35364F);
const backgroundColor = Color(0xFFE6EFF9);
const redColor = Color(0xFFE85050);

const YELLOW = Color(0xfffbed96);
const BLUE = Color(0xffabecd6);
const BLUE_DEEP = Color(0xffA8CBFD);
const BLUE_LIGHT = Color(0xffAED3EA);
const PURPLE = Color(0xffccc3fc);
const RED = Color(0xffF2A7B3);
const GREEN = Color(0xffc7e5b4);
const RED_LIGHT = Color(0xffFFC3A0);
const TEXT_BLACK = Color(0xFF353535);
const TEXT_BLACK_LIGHT = Color(0xFF34323D);


const defaultPadding = 16.0;
const myMenuPadding = 15.0;
const phoneNumWidth = 70.0;
const phoneNumPadding = 5.0;

OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: primaryColor.withOpacity(0.1),
  ),
);

// I will explain it later

const emailError = 'Enter a valid email address';
const requiredField = "This field is required";

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: '비밀번호는 필수 입력 사항입니다.'),
    MinLengthValidator(4, errorText: '비밀번호는 최소 4자리를 입력하셔야합니다.'),
    MaxLengthValidator(10, errorText: '비밀번호는 최대 10자리까지 입력 가능합니다.'),
    PatternValidator(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{1,30}$',
        errorText: '영문자, 특수문자, 숫자가 포합되어야합니다.')
  ],
);

final phoneNumberValidator = MultiValidator(
  [     
    PatternValidator(r'^(?=.*\d)[\d]{0,4}$',
        errorText: '숫자만 입력하여야합니다.')
  ],
);

void checkPNumCount(TextEditingController inputCtrl) {
    inputCtrl.text = inputCtrl.text.substring(0,4);  
    inputCtrl.selection = TextSelection.fromPosition(TextPosition(offset: inputCtrl.text.length));
  }



const firstPNums = [
    '010',
    '02',
    '051',
    '053',
    '032',
    '062',
    '042',
    '052',
    '044',
    '031',
    '033',
    '043',
    '041',
    '063',
    '061',
    '054',
    '055',
    '064',
  ];


