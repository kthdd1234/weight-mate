import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class MoreSeeItemWidget extends StatelessWidget {
  MoreSeeItemWidget({
    super.key,
    required this.index,
    required this.id,
    required this.icon,
    required this.title,
    required this.value,
    required this.widgetType,
    this.onTapArrow,
    this.onTapSwitch,
    this.bottomWidget,
    this.dateTimeStr,
    this.onTapDateTime,
  });

  int index;
  MoreSeeItem id;
  IconData icon;
  String title;
  dynamic value;
  MoreSeeWidgetTypes widgetType;
  Function(MoreSeeItem id)? onTapArrow;
  Function(MoreSeeItem id, bool value)? onTapSwitch;
  String? bottomWidget;
  String? dateTimeStr;
  Function(MoreSeeItem id, String? dateTimeStr)? onTapDateTime;

  @override
  Widget build(BuildContext context) {
    setWidget() {
      switch (widgetType) {
        case MoreSeeWidgetTypes.none:
          return Text(
            value,
            style: const TextStyle(color: disEnabledTypeColor),
          );

        case MoreSeeWidgetTypes.arrow:
          return Row(
            children: [
              Text(value, style: const TextStyle(color: disEnabledTypeColor)),
              const Icon(
                Icons.chevron_right_rounded,
                color: disEnabledTypeColor,
              )
            ],
          );

        case MoreSeeWidgetTypes.switching:
          return Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: buttonBackgroundColor,
              value: value,
              onChanged: onTapSwitch != null
                  ? (bool value) => onTapSwitch!(id, value)
                  : null,
            ),
          );

        default:
          return const EmptyArea();
      }
    }

    setBottomWidget() {
      if (bottomWidget == 'dateTime') {
        return Column(
          children: [
            SpaceHeight(height: smallSpace),
            InkWell(
              onTap: () => onTapDateTime!(id, dateTimeStr),
              child: Container(
                decoration: const BoxDecoration(
                  color: typeBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    dateTimeStr ?? '',
                    style: const TextStyle(
                      color: buttonBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return const EmptyArea();
    }

    final switchSpace = MoreSeeWidgetTypes.switching == widgetType
        ? smallSpace + tinySpace
        : regularSapce;

    return InkWell(
      onTap: () => onTapArrow != null ? onTapArrow!(id) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          index != 0
              ? SpaceHeight(height: switchSpace)
              : SpaceHeight(height: tinySpace),
          Row(
            children: [
              Icon(icon, color: buttonBackgroundColor),
              SpaceWidth(width: regularSapce),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: buttonBackgroundColor),
                ),
              ),
              setWidget(),
            ],
          ),
          setBottomWidget(),
          SpaceHeight(height: switchSpace),
          WidthDivider(
            width: MediaQuery.of(context).size.width - 165,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }
}
