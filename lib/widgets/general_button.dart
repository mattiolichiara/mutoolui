import 'package:flutter/material.dart';

import '../utils/constants.dart';

class GeneralButton extends StatelessWidget {
  final String value;
  final void Function()? onPressed;
  final void Function()? onPressedInfo;
  final void Function()? onPressedFav;
  final bool infoActive;
  final IconData? hasIcon;
  final bool canBeFavourite;
  final bool isFavourite;

  const GeneralButton({super.key, required this.value, this.onPressed, this.onPressedInfo, this.onPressedFav, this.infoActive = true, this.hasIcon, this.canBeFavourite = false, this.isFavourite = false});

  Widget handleFav(Size size) {
    if(canBeFavourite) {

      if(isFavourite) {
        return Positioned(
          height: size.width*0.03,
          width: size.width*0.03,
          top: 0,
          right: size.width*0.0175,
          child: IconButton(onPressed: onPressedFav, icon: Icon(Icons.star, color: Colors.yellow, size: size.width*Constants.iconsSize,)),
        );
      } else {
        return Positioned(
          height: size.width*0.03,
          width: size.width*0.03,
          top: 0,
          right: size.width*0.0175,
          child: IconButton(onPressed: onPressedFav, icon: Icon(Icons.star_border_outlined, color: Colors.white, size: size.width*Constants.iconsSize,)),
        );
      }


    } else {
      return Container();
    }

  }

  Widget generalButton(Size size, String value, {void Function()? onPressed, void Function()? onPressedInfo}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size.width*Constants.buttonWidth,
        height: size.height*Constants.buttonHeight,
        decoration: BoxDecoration(
          color: const Color(0xff19283b),
          borderRadius: BorderRadius.circular(8),
        ),
        child: buttonContent(size, value, onPressedInfo: onPressedInfo),
      ),
    );
  }

  Widget buttonContent(Size size, String value, {void Function()? onPressedInfo}) {
    return Stack(
      children: [
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: size.width*Constants.rowSpacing,
            children: [
              (hasIcon != null) ? Icon(
                hasIcon, color: Colors.white, size: size.width*Constants.iconsSize,) : Container(),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * Constants.fontSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        infoActive ? Positioned(
            height: size.width*0.03,
            width: size.width*0.03,
            top: 0,
            right: 0,
            child: IconButton(onPressed: onPressedInfo, icon: Icon(Icons.more_horiz, color: Colors.white, size: size.width*Constants.iconsSize,)),
        ) : Container(),
        handleFav(size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return generalButton(size, value, onPressed: onPressed, onPressedInfo: onPressedInfo);
  }
}