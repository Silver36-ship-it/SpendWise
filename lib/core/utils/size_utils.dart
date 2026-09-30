import 'package:flutter/material.dart';

const double figmaDesignWidth = 390;
const double figmaDesignHeight = 844;

Size size(BuildContext context) =>
    MediaQuery.sizeOf(context);

double width(BuildContext context) =>
    size(context).width;

double height(BuildContext context) =>
    size(context).height;

double statusBarHeight(BuildContext context) =>
    MediaQuery.of(context).viewPadding.top;

bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).orientation ==
        Orientation.landscape;

double getHorizontalSize(
    double px,
    BuildContext context,
    ) {
  return (px * width(context)) /
      (isLandscape(context)
          ? figmaDesignHeight
          : figmaDesignWidth);
}

double getVerticalSize(
    double px,
    BuildContext context,
    ) {
  return (px * height(context)) /
      (isLandscape(context)
          ? figmaDesignWidth
          : figmaDesignHeight);
}

double getSize(
    double px,
    BuildContext context,
    ) {
  final double heightSize =
  getVerticalSize(px, context);

  final double widthSize =
  getHorizontalSize(px, context);

  return (heightSize + widthSize) / 2;
}

double getFontSize(
    double px,
    BuildContext context,
    ) {
  return getSize(px, context);
}

EdgeInsets getPadding({
  required BuildContext context,
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? horizontal,
  double? vertical,
}) {
  return getMarginOrPadding(
    context: context,
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    horizontal: horizontal,
    vertical: vertical,
  );
}

EdgeInsets getMargin({
  required BuildContext context,
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    context: context,
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsets getMarginOrPadding({
  required BuildContext context,
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
  double? horizontal,
  double? vertical,
}) {
  final double finalLeft =
      all ?? left ?? horizontal ?? 0;

  final double finalTop =
      all ?? top ?? vertical ?? 0;

  final double finalRight =
      all ?? right ?? horizontal ?? 0;

  final double finalBottom =
      all ?? bottom ?? vertical ?? 0;

  return EdgeInsets.only(
    left: getHorizontalSize(
      finalLeft,
      context,
    ),
    top: getVerticalSize(
      finalTop,
      context,
    ),
    right: getHorizontalSize(
      finalRight,
      context,
    ),
    bottom: getVerticalSize(
      finalBottom,
      context,
    ),
  );
}