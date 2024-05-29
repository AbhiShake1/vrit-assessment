import 'package:flutter/material.dart';

class VritScaffold extends StatelessWidget {
  const VritScaffold({
    required this.body,
    this.bottomNavigationBar,
    super.key,
  });

  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
