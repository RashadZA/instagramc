import 'package:flutter/material.dart';
import 'package:instagramc/core/utils/design_utils.dart';

Widget cardButton({
  double? paddingForAll,
  required Function onTap,
  Color? buttonBackGroundColor,
  double? buttonWidth,
  double? buttonHeight,
  Color? buttonSplashColor,
  double? buttonBorderRadius,
  required Widget buttonChild,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(
        Radius.circular(buttonBorderRadius ?? defaultBorderRadius)),
    child: Material(
      color: buttonBackGroundColor ?? white,
      child: InkWell(
        onTap: () => onTap(),
        splashColor: buttonSplashColor ?? primaryColor,
        child: Container(
          width: buttonWidth ?? defaultIconButtonWidth,
          height: buttonHeight ?? defaultIconButtonHeight,
          padding: EdgeInsets.all(paddingForAll ?? defaultIconButtonAllPadding),
          decoration: BoxDecoration(
            color: transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(buttonBorderRadius ?? defaultBorderRadius),
            ),
          ),
          child: buttonChild,
        ),
      ),
    ),
  );
}
