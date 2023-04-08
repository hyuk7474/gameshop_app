
import 'package:flutter/material.dart';

class SnsLoginButton extends StatelessWidget {
  final Color color;
  final ImageProvider image;
  final String text;
  final VoidCallback onPressed;
  
  const SnsLoginButton({  
    required this.color,
    required this.image,
    required this.text,
    required this.onPressed,
  });

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Image(
                image: image,
                width: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle(color: color, fontSize: 10)),
                    const SizedBox(width: 35),
                  ],
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}