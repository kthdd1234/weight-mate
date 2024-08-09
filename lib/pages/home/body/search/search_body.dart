import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  @override
  Widget build(BuildContext context) {
    BottomNavigationEnum id =
        context.watch<BottomNavigationProvider>().selectedEnumId;
    bool isPremium = context.watch<PremiumProvider>().isPremium;

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) => Column(
        children: [CommonAppBar(id: id)],
      ),
    );
  }
}
