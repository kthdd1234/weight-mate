import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  String appGroupId = 'group.weight-mate-widget';
  String iosWidgetName = 'weight_mate_widget';

  initializeHomeWidget() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  updateWidgetFun({required Map<String, dynamic> data}) async {
    data.forEach((key, value) => HomeWidget.saveWidgetData(key, data));
    return await HomeWidget.updateWidget(iOSName: iosWidgetName);
  }
}
