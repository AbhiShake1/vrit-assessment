import 'package:flutter/material.dart';

void _showSnackbar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color,
    ),
  );
}

extension SnackbarX on BuildContext {
  // ignore: library_private_types_in_public_api
  _SnackbarBuilder get snackbar => _SnackbarBuilder(this);
}

extension type _SnackbarBuilder(BuildContext context) {
  void success(String text) {
    _showSnackbar(context, text, Colors.green);
  }

  void error(Object? text) {
    _showSnackbar(
      context,
      text?.toString() ?? 'Something went wrong',
      Theme.of(context).colorScheme.error,
    );
  }
}
