import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryRemove.dart';
import 'package:flutter_app_weight_management/widgets/image/default_image.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/image_pull_size_page.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistoryPicture extends StatelessWidget {
  HistoryPicture({
    super.key,
    required this.recordInfo,
    required this.isRemoveMode,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  @override
  Widget build(BuildContext context) {
    List<historyImageClass> uint8List = [
      historyImageClass(pos: 'left', unit8List: recordInfo?.leftFile),
      historyImageClass(pos: 'right', unit8List: recordInfo?.rightFile),
      historyImageClass(pos: 'bottom', unit8List: recordInfo?.bottomFile),
      historyImageClass(pos: 'top', unit8List: recordInfo?.topFile),
    ];
    List<historyImageClass> fileList = [];

    for (var i = 0; i < uint8List.length; i++) {
      historyImageClass data = uint8List[i];

      if (data.unit8List != null) {
        fileList.add(data);
      }
    }

    onTapPicture(Uint8List binaryData) {
      if (isRemoveMode == false) {
        Navigator.push(
          context,
          FadePageRoute(page: ImagePullSizePage(binaryData: binaryData)),
        );
      }
    }

    image(historyImageClass data, double height) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTapPicture(data.unit8List!),
          child: Stack(
            children: [
              DefaultImage(
                unit8List: data.unit8List!,
                height: height,
              ),
              isRemoveMode
                  ? Positioned(
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: HistoryRemove(
                          onTap: () {
                            if (data.pos == 'left') {
                              recordInfo?.leftFile = null;
                            } else if (data.pos == 'right') {
                              recordInfo?.rightFile = null;
                            } else if (data.pos == 'bottom') {
                              recordInfo?.bottomFile = null;
                            } else if (data.pos == 'top') {
                              recordInfo?.topFile = null;
                            }

                            recordInfo?.save();
                          },
                        ),
                      ),
                    )
                  : const EmptyArea()
            ],
          ),
        ),
      );
    }

    imageList() {
      switch (fileList.length) {
        case 1:
          return Row(children: [image(fileList[0], 300)]);

        case 2:
          return Row(
            children: [
              image(fileList[0], 150),
              SpaceWidth(width: 7),
              image(fileList[1], 150)
            ],
          );
        case 3:
          return Column(
            children: [
              Row(
                children: [
                  image(fileList[0], 150),
                  SpaceWidth(width: tinySpace),
                  image(fileList[1], 150)
                ],
              ),
              SpaceHeight(height: tinySpace),
              Row(children: [image(fileList[2], 150)])
            ],
          );
        case 4:
          return Column(
            children: [
              Row(children: [
                image(fileList[0], 150),
                SpaceWidth(width: tinySpace),
                image(fileList[1], 150)
              ]),
              SpaceHeight(height: tinySpace),
              Row(children: [
                image(fileList[2], 150),
                SpaceWidth(width: tinySpace),
                image(fileList[3], 150),
              ])
            ],
          );
        default:
          return const EmptyArea();
      }
    }

    return fileList.isNotEmpty
        ? Column(children: [SpaceHeight(height: 10), imageList()])
        : const EmptyArea();
  }
}
