import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class EventListenerWeight extends StatefulWidget {
  EventListenerWeight({super.key, required this.onWidgetMsg});

  Function(Object?) onWidgetMsg;

  @override
  State<EventListenerWeight> createState() => _EventListenerWeightState();
}

class _EventListenerWeightState extends State<EventListenerWeight> {
  @override
  void initState() {
    events.on(wWeightType, widget.onWidgetMsg);
    super.initState();
  }

  @override
  void dispose() {
    events.off(type: wWeightType);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const EmptyArea();
}
