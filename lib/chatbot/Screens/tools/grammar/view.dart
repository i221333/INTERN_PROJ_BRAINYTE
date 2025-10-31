import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Custom Widgets/action.dart' as action;
import '../../../Themes/colors.dart';
import '../../../Themes/fonts.dart';
import 'logic.dart';

class GrammarPage extends StatefulWidget {
  GrammarPage({Key? key}) : super(key: key);

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage>
    with SingleTickerProviderStateMixin {
  final GrammarLogic logic = Get.put(GrammarLogic());

  int selectedIndex = 0;

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
                  Get.back();
                }
              },
              icon: Center(child: SvgPicture.asset(
                  'assets/images/back.svg', height: (15 / 915) * Get.height))),
          title: Text('Grammar', style: TextStyle(color: Color(0xFF000000),
              fontFamily: SFFonts.medium,
              fontWeight: FontWeight.w500,
              fontSize: 22),),

        ),
        body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!logic.isTyping.value) {
                              setState(() => selectedIndex = 0);
                            }
                          },
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedIndex == 0
                                  ? AppColors.textPrimary
                                  : const Color(0xFFCCEEFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Checker',
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: SFFonts.medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!logic.isTyping.value) {
                              setState(() => selectedIndex = 1);
                            }
                          },
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? AppColors.textPrimary
                                  : const Color(0xFFCCEEFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Enhancer',
                              style: TextStyle(
                                color: selectedIndex == 1
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: SFFonts.medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Tab content
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: IndexedStack(
                        index: selectedIndex,
                        children: [
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            'Enter your text',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: SFFonts.regular,),
                                          ),
                                          Obx(() {
                                            if (logic.checkerLength.value != 0) {
                                              return GestureDetector(
                                                onTap: () {
                                                  logic.checker.clear();
                                                },
                                                child: Text('Clear All',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: SFFonts
                                                        .regular,),
                                                ),
                                              );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          }),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black.withOpacity(0.28),),
                                      Flexible(
                                          child:
                                          TextField(
                                            controller: logic.checker,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10000),
                                              // 👈 limit to 10000 chars
                                            ],
                                            decoration: InputDecoration(
                                                hint: Text(
                                                  'Write your text here?',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.30),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: SFFonts
                                                        .regular,),),
                                                border: InputBorder.none
                                            ),
                                            minLines: null,
                                            maxLines: null,
                                            expands: true,
                                            onTapOutside: (
                                                PointerDownEvent event) {
                                              FocusScope.of(context).unfocus();
                                            },
                                          )
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Obx(() {
                                            return Text(
                                              '${logic
                                                  .checkerLength}/10000 Characters',
                                              style: TextStyle(
                                                color: (logic.enhancerLength
                                                    .value != 10000) ? Colors
                                                    .black.withOpacity(
                                                    0.30) : Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: SFFonts.regular,),
                                            );
                                          }),
                                          GestureDetector(
                                            onTap: () async {
                                              await logic.getResponse(
                                                  'Checker',
                                                  logic.checker.text);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFCCEEFF),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Text(
                                                'Check',
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: SFFonts.regular,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                  Divider(color: Colors.black.withOpacity(0.28
                                  ),),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Obx(() {
                                        if (!logic.isTyping.value &&
                                            logic.checkerText.isEmpty)
                                          return Text(
                                            'Your Result',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: SFFonts.medium,
                                            ),
                                          );
                                        else
                                          return SizedBox.shrink();
                                      }),
                                      SizedBox(height: (10 / 915) * Get.height),
                                      Obx(() {
                                        return logic.isTyping.value ?
                                        IntrinsicWidth(
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
                                        ) : Expanded(
                                          child: SingleChildScrollView(
                                              child: Text(
                                                  logic.checkerText.value)),
                                        );
                                      }),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Obx(() {
                                          return (logic.checkerText.isNotEmpty)
                                              ?
                                          GestureDetector(
                                            onTap: () {
                                              logic.copyText(
                                                  logic.checkerText.value);
                                            },
                                            child: SvgPicture.asset(
                                              logic.copiedKeys.contains(
                                                  logic.checkerText.value)
                                                  ? 'assets/images/copied.svg'
                                                  : 'assets/images/copy.svg',
                                            ),
                                          )
                                              : SizedBox.shrink();
                                        }),
                                      )
                                    ],
                                  )),
                                ],
                              )
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            'Enter your text',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: SFFonts.regular,),
                                          ),
                                          Obx(() {
                                            if (logic.checkerLength.value != 0) {
                                              return GestureDetector(
                                                onTap: () {
                                                  logic.checker.clear();
                                                },
                                                child: Text('Clear All',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: SFFonts
                                                        .regular,),
                                                ),
                                              );
                                            } else {
                                              return SizedBox.shrink();
                                            }
                                          }),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black.withOpacity(0.28),),
                                      Flexible(
                                        child: TextField(
                                          controller: logic.enhancer,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10000),
                                            // 👈 limit to 10000 chars
                                          ],
                                          decoration: InputDecoration(
                                              hint: Text(
                                                'Write your text here?',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(
                                                      0.30),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: SFFonts
                                                      .regular,),),
                                              border: InputBorder.none
                                          ),
                                          minLines: null,
                                          maxLines: null,
                                          expands: true,
                                          onTapOutside: (
                                              PointerDownEvent event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Obx(() {
                                            return Text(
                                              '${logic
                                                  .enhancerLength}/10000 Characters',
                                              style: TextStyle(
                                                color: (logic.enhancerLength
                                                    .value != 10000) ? Colors
                                                    .black.withOpacity(
                                                    0.30) : Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: SFFonts.regular,),
                                            );
                                          }),
                                          GestureDetector(
                                            onTap: () async {
                                              await logic.getResponse(
                                                  'Enhancer',
                                                  logic.enhancer.text);
                                            }, child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFCCEEFF),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  10),
                                            ),
                                            child: Text(
                                              'Enhance',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: SFFonts.regular,
                                              ),
                                            ),
                                          ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                  Divider(
                                    color: Colors.black.withOpacity(0.28),),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Obx(() {
                                        if (!logic.isTyping.value &&
                                            logic.enhancerText.isEmpty)
                                          return Text(
                                            'Your Result',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: SFFonts.medium,
                                            ),
                                          );
                                        else
                                          return SizedBox.shrink();
                                      }),
                                      SizedBox(height: (10 / 915) * Get.height),
                                      Obx(() {
                                        return logic.isTyping.value ?
                                        IntrinsicWidth(
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
                                        ) : Expanded(
                                          child: SingleChildScrollView(
                                              child: Text(
                                                  logic.enhancerText.value)),
                                        );
                                      }),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Obx(() {
                                          return (logic.enhancerText.isNotEmpty)
                                              ?
                                          GestureDetector(
                                            onTap: () {
                                              logic.copyText(
                                                  logic.enhancerText.value);
                                            },
                                            child: SvgPicture.asset(
                                              logic.copiedKeys.contains(
                                                  logic.enhancerText.value)
                                                  ? 'assets/images/copied.svg'
                                                  : 'assets/images/copy.svg',
                                            ),
                                          )
                                              : SizedBox.shrink();
                                        }),
                                      )
                                    ],
                                  )),
                                ],
                              )
                          )
                        ],
                      ),
                    )
                ),
              ],
            )
        ),
        backgroundColor: AppColors.background,
      ),
    );
  }
}
