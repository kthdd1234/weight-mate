import 'package:flutter/material.dart';

class AppFramework extends StatelessWidget {
  AppFramework({super.key, required this.widget});

  Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Cloudy_Apple.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: widget,
    );
  }
}
