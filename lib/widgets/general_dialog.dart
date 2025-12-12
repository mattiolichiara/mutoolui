import 'package:flutter/material.dart';

import '../utils/constants.dart';

class GeneralDialog extends StatelessWidget {
  final String value;
  const GeneralDialog({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
            // width: size.width*0.5,
            // height: size.height*0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff19283b),
            ),
            child: Padding(
              padding: EdgeInsets.all(35),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(value, style: TextStyle(color: Colors.white, fontSize: size.width*Constants.fontSize, fontWeight: FontWeight.w300)),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}