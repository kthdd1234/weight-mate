import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}

class DefaultImage extends StatelessWidget {
  DefaultImage({
    super.key,
    required this.unit8List,
    required this.height,
  });

  Uint8List unit8List;
  double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.memory(
        unit8List,
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: height,
        cacheHeight: height.cacheSize(context),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;

          return frame != null
              ? child
              : Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(240, 240, 240, 1),
                  highlightColor: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
