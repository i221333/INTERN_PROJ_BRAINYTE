import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Custom Widgets/action.dart' as action;
import '../../../Themes/colors.dart';
import '../../../Themes/fonts.dart';
import 'logic.dart';

class ToolsPage extends StatelessWidget {
  String tool;
  final TextEditingController controller = TextEditingController();

  ToolsPage({super.key, required this.tool});

  final ToolsLogic logic = Get.put(ToolsLogic());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(!logic.isTyping.value);
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                if (!logic.isTyping.value) {
                  final list = logic.getListByTool(tool);
                  list.clear();
                  Get.back();
                }
              },
              icon: Center(child: SvgPicture.asset(
                  'assets/images/back.svg', height: (15 / 915) * Get.height))),
          title: Text(
            '$tool Writing', style: TextStyle(color: Color(0xFF000000),
              fontFamily: SFFonts.medium,
              fontWeight: FontWeight.w500,
              fontSize: 22),),
          actions: [
            Obx(() {
              if (logic.getListByTool(tool).isNotEmpty)
                return GestureDetector(
                  onTap: () async {
                    if (!logic.isTyping.value) {
                      await logic.exportChatAsPdf(tool);
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: action.Action(
                        path: 'assets/images/export.svg', opacity: 0.08,)
                  ),
                );
              else
                return SizedBox.shrink();
            }),
          ],
        ),
        body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    final list = logic.getListByTool(tool);

                    if (list.isEmpty) {
                      return Center(
                        child: Image.asset('assets/images/${tool
                            .toLowerCase()}.png', scale: 3,
                        ), // dynamic asset
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController
                      ,
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: (0 / 915) * Get.height),
                      itemBuilder: (context, index) {
                        final msg = list[index];
                        final isUser = msg.role ==
                            false; // false = user, true = assistant

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Prompt + Icon
                            if (isUser) Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    action.Action(
                                      path: 'assets/images/user.svg',
                                      height: 50,
                                      width: 50,
                                      backgroundColor: Colors.white,),
                                    SizedBox(width: (16 / 412) * Get.width),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            msg.message ?? '',
                                            style: const TextStyle(
                                              fontFamily: SFFonts.regular,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                              height: (12 / 915) * Get.height),
                                          Obx(() =>
                                              GestureDetector(
                                                onTap: () =>
                                                    logic.copyText(
                                                        msg.message, index),
                                                child: SvgPicture.asset(
                                                  logic.copiedKeys.contains(
                                                      index)
                                                      ? 'assets/images/copied.svg'
                                                      : 'assets/images/copy.svg',
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: (8 / 915) * Get.height),
                                Divider(color: Colors.black.withOpacity(0.20)),
                                SizedBox(height: (8 / 915) * Get.height),
                              ],
                            ),
                            // Response
                            if (!isUser) logic.isTyping.value &&
                                msg.message == '...' ? IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.blue
                                ),
                                child: SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 20, // Adjust the size as needed
                                ),
                              ),
                            ) : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                action.Action(path: '',
                                  height: 50,
                                  width: 50,
                                  backgroundColor: Colors.white,),
                                SizedBox(width: (16 / 412) * Get.width),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        msg.message ?? '',
                                        style: const TextStyle(
                                          fontFamily: SFFonts.regular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Obx(() =>
                                              GestureDetector(
                                                onTap: () =>
                                                    logic.copyText(
                                                        msg.message, index),
                                                child: SvgPicture.asset(
                                                  logic.copiedKeys.contains(
                                                      index)
                                                      ? 'assets/images/copied.svg'
                                                      : 'assets/images/copy.svg',
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          onTap: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 500),);
                            await _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          enabled: !logic.isTyping.value,
                          controller: logic.controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Ask anything to AI',
                            hintStyle: TextStyle(
                              color: Color(0xFF616472).withOpacity(0.40),
                              fontFamily: SFFonts.medium,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide
                                  .none, // removes visible border lines
                            ),
                          ),
                          style: TextStyle(color: Colors.black87),
                          onTapOutside: (PointerDownEvent event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (!logic.isTyping.value) {
                            final prompt = logic.controller.text;
                            logic.getResponse(tool, prompt);
                          }
                          else {
                            logic.stopGenerating();
                          }
                        },
                        child: Obx(() {
                          return Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: action.Action(
                                path: (logic.isTyping.value)
                                    ? 'assets/images/loading.svg'
                                    : 'assets/images/send.svg',
                                height: 50,
                                width: 50,)
                          );
                        })
                    ),
                  ],
                )
              ],
            )
        ),
        backgroundColor: AppColors.background,
      ),
    );
  }
}
