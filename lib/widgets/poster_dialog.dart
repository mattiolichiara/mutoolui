import 'package:flutter/material.dart';
import 'package:mutoolui/widgets/operation_text_box.dart';

import '../utils/constants.dart';

class PosterDialog extends StatefulWidget {
  final String value;
  const PosterDialog({super.key, required this.value});

  @override
  State<PosterDialog> createState() => _PosterDialog();
}

class _PosterDialog extends State<PosterDialog> {
  bool enabled = true;

  Widget addSubtractButtons(Size size) {
    final iconColor = Colors.white;
    final iconSize = Constants.iconsSize*1500;
    final buttonHeight = size.height*0.025;
    final buttonWidth = size.height*0.028;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //color: Colors.grey.withAlpha(20),
          ),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_up_rounded, color: iconColor,
              size: iconSize,), onPressed: () {},
          ),
        ),
        Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //color: Colors.grey.withAlpha(20),
          ),
          child: IconButton(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: iconColor,
              size: iconSize), onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget xBoxWinkWink(Size size, String text) {
    return SizedBox(
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize*1.1),),
          SizedBox(width: size.width*0.0061,),
          OperationTextBox(height: size.height*0.05, width: size.width*0.03, enabled: enabled,),
          //SizedBox(width: size.width*0.007,),
          addSubtractButtons(size),
        ],
      ),
    );
  }

  Widget xBoxWrapper(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(value: enabled, onChanged: (value) {
          setState(() {
            enabled = value!;
          });
          // debugPrint("Enabled: $enabled + Value: $value");
        }),
        SizedBox(width: size.width*0.005,),
        xBoxWinkWink(size, "X"),
        SizedBox(width: size.width*0.03,),
        xBoxWinkWink(size, "Y"),
      ],
    );
  }

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
                    xBoxWrapper(size),
                    SizedBox(
                      height: size.height*0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: size.height*0.02,
                      children: [
                        OperationTextBox(width: size.width*0.3, height: size.height*0.1, hintText: "Insert additional commands",),
                        submitButton(size),
                      ],
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Text(widget.value),
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