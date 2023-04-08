// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MemberInfo {
  late String mId;
  late String mName;
  late String mPnum;
  late String mEmail;
  late int mBlack;
  late int status;
  MemberInfo({
    required this.mId,
    required this.mName,
    required this.mPnum,
    required this.mEmail,
    required this.mBlack,
    required this.status,
  });
}
