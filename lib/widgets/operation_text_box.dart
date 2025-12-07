import 'package:flutter/material.dart';

import '../utils/constants.dart';

class OperationTextBox extends StatefulWidget {
  final double height;
  final double width;
  final String? hintText;
  final bool enabled;
  final int maxLines;
  const OperationTextBox({super.key, required this.height, required this.width, this.enabled=true, this.hintText, this.maxLines = 1});

  @override
  State<OperationTextBox> createState() => _OperationTextBox();
}

class _OperationTextBox extends State<OperationTextBox> {
  TextEditingController _operationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        enabled: widget.enabled,
        controller: _operationController,
        obscureText: false,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
            border: OutlineInputBorder(
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize, fontStyle: FontStyle.italic)),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: size.width * Constants.fontSize),
      ),
    );
  }

}