// utils.dart

import 'package:Mowasil/helper/app_colors.dart';
import 'package:Mowasil/User/OrderStatus/order_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(
    BuildContext context,
    String description,
    void Function() OkFunction,
    void Function() CancelFunction,
    String title,
    String btnOkText,
    String btnCancelText,
    DialogType dialogType 
    
    ) {
  AwesomeDialog(
          context: context,
          keyboardAware: true,
          dismissOnBackKeyPress: false,
          dialogType:dialogType ,
          animType: AnimType.topSlide,
          dialogBackgroundColor: Color.fromARGB(255, 232, 232, 233),
          btnCancelText: btnCancelText,
          btnOkText: btnOkText,
          title: title,
          desc: description,
          descTextStyle: TextStyle(fontSize: 20),
          btnOkColor: ButtonsColor2,
          btnCancelColor: Color.fromARGB(255, 70, 64, 57),
          btnCancelOnPress: CancelFunction,
          btnOkOnPress: OkFunction)
      .show();
}
