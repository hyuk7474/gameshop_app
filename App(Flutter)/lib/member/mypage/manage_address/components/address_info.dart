// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressInfo {
  late String aName;
  late String aZipcode;
  late String aMain;
  late String? aSub;
  late String aPrimary;


  AddressInfo({
    required this.aName,
    required this.aZipcode,
    required this.aMain,
    required this.aSub,
    required this.aPrimary,
  });

  AddressInfo.empty();

}
