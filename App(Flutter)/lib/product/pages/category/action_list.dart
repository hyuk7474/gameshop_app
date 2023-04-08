import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen.dart';
import 'package:shopping_ui/product/pages/search_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class ActionGameList extends StatefulWidget {
  const ActionGameList({Key? key}) : super(key: key);

  @override
  State<ActionGameList> createState() => _ActionGameListState();
}

class _ActionGameListState extends State<ActionGameList> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  //_ActionGameListState(this.documentId);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "Action Game",
          style: TextStyle(color: accent),
        ),
        actions: <Widget> [
              IconButton(
                  onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const Search2Page())),
                  icon: Icon(Icons.search), color: accent,),
            ],
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").doc('category').collection('action').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return SizedBox(
            height: 700,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                //padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      title: snapshot.data!.docs[index]['gTitle'],
                      price: snapshot.data!.docs[index]['gPrice'],
                      story: snapshot.data!.docs[index]['gStory'],
                      ex: snapshot.data!.docs[index]['gEx'],
                      spec: snapshot.data!.docs[index]['gSpec'], 
                      imgurl: snapshot.data!.docs[index]['imgurl'],
                      imgurl1: snapshot.data!.docs[index]['imgurl1'],
                      imgurl2: snapshot.data!.docs[index]['imgurl2'],
                      imgurl3: snapshot.data!.docs[index]['imgurl3'],
                      press: () {
                        // _imgurl = snapshot.data!.docs[index]['imgurl'];
                        
                        DetailInfo detailInfo = DetailInfo(
                          imgurl: snapshot.data!.docs[index]['imgurl'],
                          imgurl1: snapshot.data!.docs[index]['imgurl1'],
                          imgurl2: snapshot.data!.docs[index]['imgurl2'],
                          imgurl3: snapshot.data!.docs[index]['imgurl3'],
                          price: snapshot.data!.docs[index]['gPrice'],
                          title: snapshot.data!.docs[index]['gTitle'],
                          story: snapshot.data!.docs[index]['gStory'],
                          ex: snapshot.data!.docs[index]['gEx'],
                          spec: snapshot.data!.docs[index]['gSpec'],
                          
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(detailInfo: detailInfo,)));
                      }, 
                    ) 
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}

class Card extends StatelessWidget {
  final String title, price, story, ex, spec,
        imgurl, imgurl1, imgurl2, imgurl3;
  //final int price;
  final GestureTapCallback press;

  const Card({
    Key? key,
    required this.title,
    required this.price,
    required this.story,
    required this.imgurl,
    required this.imgurl1,
    required this.imgurl2,
    required this.imgurl3,
    required this.press, 
    required this.ex, 
    required this.spec, 

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: 330,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.network(
                      '$imgurl',
                      fit: BoxFit.cover,
                    ),
                    // Image.network(
                    //   '$imgurl2',
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),
                
                // Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         accent,
                //         Color.fromARGB(0, 160, 160, 160),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10, top: 140
                  ),
                  child: BorderedText(
                    strokeWidth: 5,
                    strokeColor: accent,
                    child: Text(
                      "$title\n￦$price",
                      style: TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold
                        // decoration: TextDecoration.none,
                        // decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                ),

                  // child: Text.rich(
                  //   TextSpan(
                  //     style: TextStyle(
                  //       color: Colors.white,  
                  //     ),
                  //     children: [
                  //       TextSpan(
                  //         text: "$title\n",
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: "￦$price",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}