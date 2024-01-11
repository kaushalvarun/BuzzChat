import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String errorMsg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.amber[200],
        title: Text(errorMsg),
      );
    },
  );
}
