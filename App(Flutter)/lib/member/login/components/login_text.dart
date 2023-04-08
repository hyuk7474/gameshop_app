import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginText extends StatelessWidget {

  final String text;

  const LoginText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.w600
        ),
    );
  }
}