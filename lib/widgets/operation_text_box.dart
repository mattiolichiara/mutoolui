import 'package:flutter/material.dart';

import '../utils/constants.dart';

class OperationTextBox extends StatefulWidget {
  final double height;
  final double width;
  final String? hintText;
  final bool enabled;
  final int maxLines;
  final bool readOnly;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextEditingController operationController;
  const OperationTextBox({super.key, required this.height, required this.width, this.enabled=true, this.hintText, this.maxLines = 1,
    required this.operationController, this.onChanged, this.readOnly=false, this.suffixIcon});

  @override
  State<OperationTextBox> createState() => _OperationTextBox();
}

class _OperationTextBox extends State<OperationTextBox> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        controller: widget.operationController,
        obscureText: false,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
            border: OutlineInputBorder(
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize, fontStyle: FontStyle.italic)),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize),
      ),
    );
  }

}