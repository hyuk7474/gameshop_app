import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/product/constants.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/widgets/modal/buymodal.dart';
import 'package:shopping_ui/widgets/modal/gtareviermodal.dart';
import 'package:shopping_ui/widgets/modal/rdrreviewmodal.dart';
import 'package:shopping_ui/widgets/modal/reviewmodal.dart';
import 'package:shopping_ui/widgets/modal/wit3reviewmodal.dart';


class TempDetailScreen2 extends StatefulWidget {

  late DetailInfo pInfo;  
    
  TempDetailScreen2({
      Key? key,
      required this.pInfo       
    }) : super(key: key);

  @override
  State<TempDetailScreen2> createState() => _TempDetailScreen2State();
}

class _TempDetailScreen2State extends State<TempDetailScreen2> {
  
  late String title = widget.pInfo.title;
  late String price = widget.pInfo.price;
  late String story = widget.pInfo.story;
  late String imgurl = widget.pInfo.imgurl;
  late String imgurl1 = widget.pInfo.imgurl1;
  late String imgurl2 = widget.pInfo.imgurl2;
  late String imgurl3 = widget.pInfo.imgurl3;
  

  

  

  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: getBody()
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "$title",
          style: TextStyle(color: accent),
        ),
        actions: <Widget> [
              IconButton(
                  onPressed: () {
                    // getInfo().then((value) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => CartList(detailInfo: value)));
                    // });
                  },
                  icon: Icon(Icons.shopping_cart, color: accent,)
              ),
            ],
    );
  }

  Widget getBody() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
             Image.network(
              '$imgurl',
              fit: BoxFit.cover,
             ),
             SizedBox(height: 10,),
             Text('Screen Shot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
             Text('swipe left or right', style: TextStyle(fontSize: 13),),
             Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: bar,
                ),
              child: Container(
                // width: 400,
                height: 250,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Image.network(
                            '$imgurl1',
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            '$imgurl2',
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            '$imgurl3',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),
            Text('Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: bar,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30),
                //   topRight: Radius.circular(30),
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text('$story', style: TextStyle(fontSize: 17),)
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10,),
            Text('Detail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text('swipe left or right', style: TextStyle(fontSize: 13),),
            Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: bar,
                ),
              child: Container(
                height: 250,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(25),
                  
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: 
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: bar,
            border: Border(top: BorderSide(color: Color.fromARGB(255, 95, 208, 236).withOpacity(0.5))),  
          ),
          
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                style: ElevatedButton.styleFrom(primary: accent),
                onPressed: () {                  
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    barrierColor: Colors.black.withOpacity(.7),
                      context: context,
                      builder: (_) {                        
                        return BuyModal(detailInfo: widget.pInfo,);
                      },
                  );
                },
                child: Text("￦$price 구매하기", style: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.bold,),),
                ),
          
                SizedBox(width: 20,),
                ElevatedButton(
                style: ElevatedButton.styleFrom(primary: accent),
                onPressed: () {
                  // 미구현                  
                },
                child: Text("장바구니", style: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.bold,),),
                ),
          
                SizedBox(width: 20,),
                ElevatedButton(
                style: ElevatedButton.styleFrom(primary: accent),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    barrierColor: Colors.black.withOpacity(.7),
                      context: context,
                      builder: (_) {
                        if(imgurl == 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Frdr2.jpg?alt=media&token=aeffe752-8710-459c-a34b-63b05e0e201e') {
                          return RdrReviewModal();
                        }
                        else if(imgurl == 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fgta5.jpg?alt=media&token=02099b3c-73a8-4122-9774-c3824ed6e342') {
                          return GtaReviewModal();
                        }
                        else if(imgurl == 'https://firebasestorage.googleapis.com/v0/b/flutter-exam-6ac39.appspot.com/o/products%2Fwitcher3.jpg?alt=media&token=7f28684b-78b9-4471-8177-7514b9eff146') {
                          return Wit3ReviewModal();
                        }
                        else {
                          return ReviewModal();
                        }
                      },
                  );
                },
                child: Text("리뷰 모달", style: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.bold,),),
                ),
              ],
            ),
          ),
        ),
    );
  }
}