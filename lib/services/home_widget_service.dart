import 'dart:developer';

import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  String appGroupId = 'group.weight-mate-widget';

  initializeHomeWidget() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  interactiveWidgetCallback() {
    // HomeWidget.registerInteractivityCallback(interactiveCallback);
  }

  updateWeightWidget({required Map<String, String> data}) async {
    data.forEach((key, value) async {
      await HomeWidget.saveWidgetData<String>(key, value);
    });

    return await HomeWidget.updateWidget(iOSName: "weightMateWidget");
  }
}
