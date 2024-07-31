import 'package:flutter/material.dart';
import 'package:mathsgames/src/core/app_constant.dart';
import 'package:mathsgames/src/data/models/mental_arithmetic.dart';
import 'package:mathsgames/src/ui/common/common_app_bar.dart';
import 'package:mathsgames/src/ui/common/common_back_button.dart';
import 'package:mathsgames/src/ui/common/common_clear_button.dart';
import 'package:mathsgames/src/ui/common/common_info_text_view.dart';
import 'package:mathsgames/src/ui/common/common_neumorphic_view.dart';
import 'package:mathsgames/src/ui/common/common_number_button.dart';
import 'package:mathsgames/src/ui/common/common_wrong_answer_animation_view.dart';
import 'package:mathsgames/src/ui/common/dialog_listener.dart';
import 'package:mathsgames/src/ui/mentalArithmetic/mental_arithmetic_provider.dart';
import 'package:mathsgames/src/ui/mentalArithmetic/mental_arithmetic_question_view.dart';
import 'package:mathsgames/src/ui/model/gradient_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:vsync_provider/vsync_provider.dart';

import '../../utility/Constants.dart';
import '../common/common_main_widget.dart';

class MentalArithmeticView extends StatelessWidget {
  final Tuple2<GradientModel, int> colorTuple;

  MentalArithmeticView({
    Key? key,
    required this.colorTuple,
  }) : super(key: key);

  final List<String> list = [
    "7",
    "8",
    "9",
    "4",
    "5",
    "6",
    "1",
    "2",
    "3",
    "-",
    "0",
    "Back"
  ];

  @override
  Widget build(BuildContext context) {
    double remainHeight = getRemainHeight(context: context);
    int _crossAxisCount = 3;
    double height1 = getScreenPercentSize(context, 57);
    double height = getScreenPercentSize(context, 57) / 5.3;

    double _crossAxisSpacing = getPercentSize(height, 30);
    var widthItem = (getWidthPercentSize(context, 100) -
            ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;

    double _aspectRatio = widthItem / height;
    var margin = getHorizontalSpace(context);
    double mainHeight = getMainHeight(context);
    return MultiProvider(
      providers: [
        const VsyncProvider(),
        ChangeNotifierProvider<MentalArithmeticProvider>(
            create: (context) => MentalArithmeticProvider(
                vsync: VsyncProvider.of(context),
                level: colorTuple.item2,
                context: context))
      ],
      child: DialogListener<MentalArithmeticProvider>(
        colorTuple: colorTuple,
        appBar: CommonAppBar<MentalArithmeticProvider>(
            infoView: CommonInfoTextView<MentalArithmeticProvider>(
                gameCategoryType: GameCategoryType.MENTAL_ARITHMETIC,
                folder: colorTuple.item1.folderName!,
                color: colorTuple.item1.cellColor!),
            gameCategoryType: GameCategoryType.MENTAL_ARITHMETIC,
            colorTuple: colorTuple,
            context: context),
        level: colorTuple.item2,
        gameCategoryType: GameCategoryType.MENTAL_ARITHMETIC,
        child: CommonMainWidget<MentalArithmeticProvider>(
          gameCategoryType: GameCategoryType.MENTAL_ARITHMETIC,
          color: colorTuple.item1.bgColor!,
          primaryColor: colorTuple.item1.primaryColor!,
          subChild: Container(
            margin: EdgeInsets.only(top: getPercentSize(mainHeight, 55)),
            child: Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              bottom: getPercentSize(mainHeight, 15)),

                          child: Selector<MentalArithmeticProvider,
                                  MentalArithmetic>(
                              selector: (p0, p1) => p1.currentState,
                              builder: (context, currentState, child) {
                                return MentalArithmeticQuestionView(
                                  currentState: currentState,
                                );
                              }),
                        ),
                      ),
                      Container(
                        height: height1,
                        decoration: getCommonDecoration(context),
                        alignment: Alignment.bottomCenter,
                        child: Builder(builder: (context) {
                          return GridView.count(
                            crossAxisCount: _crossAxisCount,
                            childAspectRatio: _aspectRatio,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              right: (margin * 2),
                              left: (margin * 2),
                              bottom: getHorizontalSpace(context),
                            ),
                            crossAxisSpacing: _crossAxisSpacing,
                            mainAxisSpacing: _crossAxisSpacing,
                            primary: false,
                            // padding: EdgeInsets.only(top: getScreenPercentSize(context, 4)),
                            children: List.generate(list.length, (index) {
                              String e = list[index];
                              if (e == "Clear") {
                                return CommonClearButton(
                                    text: "Clear",
                                    height: height,
                                    onTab: () {
                                      context
                                          .read<MentalArithmeticProvider>()
                                          .clearResult();
                                    });
                              } else if (e == "Back") {
                                return CommonBackButton(
                                  onTab: () {
                                    context
                                        .read<MentalArithmeticProvider>()
                                        .backPress();
                                  },
                                  height: height,
                                );
                              } else {
                                return CommonNumberButton(
                                  text: e,
                                  totalHeight: remainHeight,
                                  height: height,
                                  onTab: () {
                                    context
                                        .read<MentalArithmeticProvider>()
                                        .checkResult(e);
                                  },
                                  colorTuple: colorTuple,
                                );
                              }
                            }),
                          );
                        }),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: getPercentSize(height1, 17)),
                    child: Selector<MentalArithmeticProvider,
                        Tuple2<double, double>>(
                      selector: (p0, p1) =>
                          Tuple2(p1.currentScore, p1.oldScore),
                      builder: (context, tuple2, child) {
                        return CommonWrongAnswerAnimationView(
                          currentScore: tuple2.item1.toInt(),
                          oldScore: tuple2.item2.toInt(),
                          child: child!,
                        );
                      },
                      child: CommonNeumorphicView(
                        isLarge: true,
                        isMargin: false,
                        height: getPercentSize(height1, 12),
                        color: getBackGroundColor(context),
                        child: Selector<MentalArithmeticProvider, String>(
                          selector: (p0, p1) => p1.result,
                          builder: (context, result, child) {
                            return getTextWidget(
                                Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontWeight: FontWeight.w600),
                                result.length > 0 ? result : '?',
                                TextAlign.center,
                                getPercentSize(height1, 7));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          context: context,
          isTopMargin: false,
        ),
      ),
    );
  }
}
