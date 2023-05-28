import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ActTypeWidget extends StatefulWidget {
  ActTypeWidget({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  dynamic initId;
  dynamic id;
  String title;
  String desc;
  IconData icon;
  bool isEnabled;
  Function(dynamic id) onTap;

  @override
  State<ActTypeWidget> createState() => _ActTypeWidgetState();
}

class _ActTypeWidgetState extends State<ActTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => widget.onTap(widget.id),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? buttonBackgroundColor
                  : typeBackgroundColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: pagePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.isEnabled ? buttonTextColor : primaryColor,
                        ),
                      ),
                      SpaceHeight(height: tinySpace),
                      Text(
                        widget.desc,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: widget.isEnabled
                              ? enabledTypeColor
                              : disEnabledTypeColor,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xffffffff),
                    child: Icon(widget.icon),
                  )
                ],
              ),
            ),
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}
