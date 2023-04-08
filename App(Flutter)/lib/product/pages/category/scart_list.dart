import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:shopping_ui/constant/json/constant.dart';
import 'package:shopping_ui/constant/theme/colors.dart';
import 'package:shopping_ui/product/components/detail.dart';
import 'package:shopping_ui/product/components/detail2.dart';
import 'package:shopping_ui/product/components/sdetail.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen.dart';
import 'package:shopping_ui/product/pages/actiongame/detailscreen2.dart';
import 'package:shopping_ui/product/pages/actiongame/sdetailscreen.dart';
import 'package:shopping_ui/product/pages/search_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class SCartList extends StatefulWidget {
  //DetailInfo? detailInfo;

 const SCartList({Key? key,}) : super(key: key);

  @override
  State<SCartList> createState() => _SCartListState();
}

class _SCartListState extends State<SCartList> {

  // get title => widget.detailInfo?.title;
  // get price => widget.detailInfo?.price;
  // get story => widget.detailInfo?.story;
  // get imgurl => widget.detailInfo?.imgurl;
  // get imgurl1 => widget.detailInfo?.imgurl1;
  // get imgurl2 => widget.detailInfo?.imgurl2;
  // get imgurl3 => widget.detailInfo?.imgurl3;
  // get ex => widget.detailInfo?.ex;
  // get spec => widget.detailInfo?.spec;

  final String colName = "scart";
  final String fnTitle = "gTitle";
  final String fnPrice = "gPrice";
  final String fnSPrice = "gsPrice";
  final String fnImg = "imgurl";

  final String fnEx = "gEx";
  final String fnSpec = "gSpec";
  final String fnStory = "gStory";
  final String fnImg1 = "imgurl1";
  final String fnImg2 = "imgurl2";
  final String fnImg3 = "imgurl3";

  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undPriceCon = TextEditingController();
  TextEditingController _undSPriceCon = TextEditingController();
  TextEditingController _undImgCon = TextEditingController();
  TextEditingController _undImg1Con = TextEditingController();
  TextEditingController _undImg2Con = TextEditingController();
  TextEditingController _undImg3Con = TextEditingController();
  TextEditingController _undStoryCon = TextEditingController();
  TextEditingController _undExCon = TextEditingController();
  TextEditingController _undSpecCon = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late CollectionReference cart;
  
  @override
  void initState() {
    super.initState();
    cart = FirebaseFirestore.instance.collection('scart');
  }
  //_ActionGameListState(this.documentId);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.8,
        backgroundColor: Color.fromARGB(255, 212, 246, 255),
        title: Text(
          "My Cart",
          style: TextStyle(color: accent),
        ),
        // actions: <Widget> [
        //       IconButton(
        //           onPressed: () => Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (_) => const Search2Page())),
        //           icon: Icon(Icons.search), color: accent,),
        //     ],
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("scart").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)Center(
            child: CircularProgressIndicator(),
          );
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              if(snapshot.data!.docs.isEmpty) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text('Your cart is empty')
                    ],
                  ),
                );
              }
              else {
               return ListTile(
                  title: Text(
                    data['gTitle'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        data['gPrice'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(' -> ', style: TextStyle(fontSize: 25),),
                      Text(
                        data['gsPrice'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data['imgurl']),
                    ), 
                  ),
                  trailing: SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        print('delete');
                        _deleteProduct(snapshot.data!.docs[index].id);
                      }
                    ),
                  ),
                  onTap: () {
                        SDetailInfo sdetailInfo = SDetailInfo(
                          title: snapshot.data!.docs[index]['gTitle'],
                          price: snapshot.data!.docs[index]['gPrice'],
                          sprice: snapshot.data!.docs[index]['gsPrice'],
                          story: snapshot.data!.docs[index]['gStory'],
                          ex: snapshot.data!.docs[index]['gEx'],
                          spec: snapshot.data!.docs[index]['gSpec'], 
                          imgurl: snapshot.data!.docs[index]['imgurl'],
                          imgurl1: snapshot.data!.docs[index]['imgurl1'],
                          imgurl2: snapshot.data!.docs[index]['imgurl2'],
                          imgurl3: snapshot.data!.docs[index]['imgurl3'],
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SDetailScreen(sdetailInfo: sdetailInfo)));
                      },
                  // onLongPress: () {
                  //   showDeleteDocDialog(document);
                  // },        
                ); 
              }
              return Container();
            }
          );
        }
      ),
      bottomNavigationBar: 
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: bar,
            border: Border(top: BorderSide(color: Color.fromARGB(255, 95, 208, 236).withOpacity(0.5))),  
          ),

          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              ElevatedButton(
                child: Text('구매하기'),
                style: ElevatedButton.styleFrom(primary: accent),
                onPressed: () {

                },
              )
            ],
          ),
        ),
    );
  }

  void _deleteProduct(String id) {
   FirebaseFirestore.instance.collection('scart').doc(id).delete();
  }
}