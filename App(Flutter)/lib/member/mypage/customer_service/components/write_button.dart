import 'package:flutter/material.dart';
import 'package:shopping_ui/member/mypage/customer_service/qna/write_qna.dart';

class WriteButton extends StatelessWidget {
  const WriteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(                
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: ((context) => QnaWritePage())
                      )
                    );
                  }, 
                  child: Text('글 작성'),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ),
            );
  }
}