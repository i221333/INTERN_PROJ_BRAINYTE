import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Themes/colors.dart';
import '../Themes/fonts.dart';

class Tool extends StatelessWidget {
  String path;
  String title;
  String content;

  Tool({
    super.key,
    required this.path,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child:
      Container(
          width: (180 / 412) * Get.width,
          height: (160 / 915) * Get.height,
          decoration: BoxDecoration(
              color: (Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (50 / 412) * Get.width,
                  height: (50 / 915) * Get.height,
                  decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(child: SvgPicture.asset(path, height: 30,)),
                ),
                Spacer(),
                Text(title, style: TextStyle(color: Color(0xFF000000), fontFamily: SFFonts.medium, fontWeight: FontWeight.w500, fontSize: 16),),
                Text(content, style: TextStyle(color: Color(0xFF616472).withOpacity(0.50), fontFamily: SFFonts.regular, fontWeight: FontWeight.w400, fontSize: 10),),
              ],
            ),
          )
      ),
    );
  }
}
