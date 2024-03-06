import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  String appGroupId = 'group.weight-mate-widget';

  initializeHomeWidget() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  updateWidgetFun({required Map<String, dynamic> data}) async {
    data.forEach((key, value) async {
      await HomeWidget.saveWidgetData<String>(key, value);
    });
    await HomeWidget.updateWidget(iOSName: "weightMateWidget");
    return;
  }
}
