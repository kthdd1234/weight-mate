// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/etc/add_body_unit.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class BodyUnitPage extends StatefulWidget {
  const BodyUnitPage({super.key});

  @override
  State<BodyUnitPage> createState() => _BodyUnitPageState();
}

class _BodyUnitPageState extends State<BodyUnitPage> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String? sTallUnit = user.tallUnit ?? 'cm';
    String? sWeightUnit = user.weightUnit ?? 'kg';

    onTap({required String type, required String unit}) {
      if (type == 'tall') {
        String? tall = convertTall(unit: unit, tall: '${user.tall}');

        user.tall = double.tryParse(tall ?? '${user.tall}') ?? user.tall;
        user.tallUnit = unit;
      } else if (type == 'weight') {
        List<RecordBox> recordList = recordRepository.recordList.toList();

        recordList.forEach(
          (record) {
            if (record.weight != null) {
              String? weight = convertWeight(
                unit: unit,
                wegiht: '${record.weight}',
              );

              record.weight = double.tryParse(weight!);
              record.save();
            }
          },
        );
        user.weightUnit = unit;

        String? goalWeight = convertWeight(
          unit: unit,
          wegiht: '${user.goalWeight}',
        );
        user.goalWeight = double.tryParse(goalWeight!)!;
      }

      user.save();
      setState(() {});
    }

    return AppFramework(
      widget: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        appBar: AppBar(
          title: Text('단위 변경'.tr(), style: const TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              UnitBox(
                sTallUnit: sTallUnit,
                sWeightUnit: sWeightUnit,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
