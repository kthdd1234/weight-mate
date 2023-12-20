import 'dart:developer';

import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/repositories/mate_hive.dart';
import 'package:hive/hive.dart';

class PlanRepository {
  Box<PlanBox>? _planBox;

  Box<PlanBox> get planBox {
    _planBox = Hive.box<PlanBox>(MateHiveBox.planBox);
    return _planBox!;
  }

  void addPlan(PlanBox plan) async {
    int key = await planBox.add(plan);

    log('[addPlan] add (key:$key) $plan');
    log('result ${planBox.values.toList()}');
  }

  void deletePlan(int key) async {
    await planBox.delete(key);

    log('[deletePlan] delete (key:$key)');
    log('result ${planBox.values.toList()}');
  }

  void updatePlan({required dynamic key, required PlanBox plan}) async {
    await planBox.put(key, plan);

    log('[updatePlan] update (key:$key) $plan');
    log('result ${planBox.values.toList()}');
  }
}
