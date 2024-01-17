import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String errorMsg) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.amber[200],
      title: Text(errorMsg),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Center(
            child: Text('OK'),
          ),
        ),
      ],
    ),
  );
}
