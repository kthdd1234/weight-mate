import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/provider/reload_provider.dart';
import 'package:provider/provider.dart';

class CommonBackground extends StatelessWidget {
  CommonBackground({
    super.key,
    required this.child,
    this.isRadius,
    this.height,
    this.borderRadius,
    this.padding,
  });

  bool? isRadius;
  double? height;
  BorderRadius? borderRadius;
  EdgeInsets? padding;
  Widget child;

  @override
  Widget build(BuildContext context) {
    context.watch<ReloadProvider>().isReload;
    String theme = userRepository.user.theme ?? '1';

    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      height: height ?? MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ??
            BorderRadius.circular(isRadius == true ? 10.0 : 0.0),
        image: DecorationImage(
          image: AssetImage('assets/images/b-$theme.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
