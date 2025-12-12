import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/operation_text_box.dart';

import '../utils/constants.dart';

class RunJsDialog extends StatefulWidget {
  const RunJsDialog({super.key});

  @override
  State<RunJsDialog> createState() => _OperationsDialog();
}

class _OperationsDialog extends State<RunJsDialog> {
  TextEditingController jsCodeController = TextEditingController();
  bool submitted = false;

  Widget submitButton(Size size, void Function()? onPressed, {String text = "Submit"}) {
    return Container(
      width: size.width*0.06,
      height: size.height*0.05,
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
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize)),
      ),
    );
  }
  
  Widget runJs(Size size) {
    return Column(
      children: [
        OperationTextBox(width: size.width*0.3, height: size.height*0.7, hintText: "Insert code", maxLines: 28, operationController: jsCodeController,),
        submitButton(size, () {}),
      ],
    );
  }
  
  Widget runMuTool(Size size) {
    return Center(
        child: Column(
          children: [
            Text("mutool run", style:TextStyle(fontSize: size.width * Constants.fontSize*1.03, fontWeight: FontWeight.w300, color: Colors.white70, fontStyle: FontStyle.italic),),
            SizedBox(
              height: size.height*0.03,
            ),
            submitButton(size, text: "Run", () {
              setState(() {
                submitted = true;
              });
            },),
          ],
        )
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
              child: submitted ? runJs(size) : runMuTool(size),
            ),
          ),
        ),
      ),
    );
  }
}