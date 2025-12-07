import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/operation_text_box.dart';

import '../utils/constants.dart';

class OperationsDialog extends StatefulWidget {
  final String value;
  const OperationsDialog({super.key, required this.value});

  @override
  State<OperationsDialog> createState() => _OperationsDialog();
}

class _OperationsDialog extends State<OperationsDialog> {

  Widget submitButton(Size size) {
    return Container(
      width: size.width*0.05,
      height: size.height*0.045,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: BoxBorder.all(
            color: Colors.white,
          )
      ),
      child: TextButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )
            )
        ),
        onPressed: () {},
        child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize)),
      ),
    );
  }

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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: size.height*0.02,
                    children: [
                      OperationTextBox(width: size.width*0.3, height: size.height*0.1, hintText: "Insert additional commands",),
                      submitButton(size),
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.01,
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(widget.value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}