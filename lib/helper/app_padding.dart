import 'package:flutter/material.dart';

extension AppPadding on Widget {
  //All Side Padding
  Widget paddingAll({double padding = 8}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget paddingSymmetric({
    double horizontal = 8,
    double vertical = 8,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  Widget paddingOnly({
    double left = 8,
    double right = 8,
    double top = 8,
    double bottom = 8,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: this,
    );
  }

  Widget paddingFromLTRB({
    double left = 8,
    double top = 8,
    double right = 8,
    double bottom = 8,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }
}
