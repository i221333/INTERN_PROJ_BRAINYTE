import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Themes/colors.dart';

class Action extends StatelessWidget {
  String path;
  double? width;
  double? height;
  double? opacity;
  Color? backgroundColor;

  Action({
    super.key,
    required this.path,
    this.width = 40,
    this.height = 40,
    this.opacity = 1,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: (width! / 412) * Get.width,
        height: (height! / 915) * Get.height,
        decoration: BoxDecoration(
          color: (backgroundColor ?? AppColors.textPrimary).withOpacity(opacity!),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: (backgroundColor ?? AppColors.textPrimary)),
        ),
        child: Center(
          child: SvgPicture.asset(
            path,
            colorFilter: opacity == 1 && backgroundColor == null
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : null,
          ),
        )
    );
  }
}