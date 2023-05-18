import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/list_view/scrollbar_list_view.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/check/add_diet_plan_check.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/touch_and_check_input_widget.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoList extends StatefulWidget {
  const AddTodoList({super.key});

  @override
  State<AddTodoList> createState() => _AddTodoListState();
}

class _AddTodoListState extends State<AddTodoList> {
  late Box<UserInfo> userInfoBox;

  List<DietPlanClass> dietPlanList = [];
  bool showTouchArea = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() async {
    super.initState();

    dietPlanList = defaultDietPlanList;
    userInfoBox = Hive.box<UserInfo>('userInfoBox');
  }

  @override
  Widget build(BuildContext context) {
    getCheckList() {
      return dietPlanList.where((dietPlan) => dietPlan.isChecked).toList();
    }

    onPressedBottomNavigationButton() {
      final checkList = getCheckList();
      final readProvider = context.read<DietInfoProvider>();
      final userInfo = readProvider.getUserInfo();

      if (checkList.isNotEmpty) {
        readProvider.changeDietPlanList(checkList);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-container',
          (_) => false,
        );

        // userInfoBox.add(
        //   UserInfo(
        //     recordDateTime: DateTime.now(),
        //     tall: userInfo.tall,
        //     weight: userInfo.weight,
        //     goalWeight: userInfo.goalWeight,
        //     startDietDateTime: userInfo.startDietDateTime,
        //     endDietDateTime: userInfo.endDietDateTime,
        //     dietPlanList: checkList,
        //     bodyFat: 0.0,
        //     memo: '',
        //   ),
        // );
      }
    }

    onTapEmptyArea() {
      setState(() => showTouchArea = false);
    }

    onTapCheck(String id) {
      setState(() {
        dietPlanList = dietPlanList.map((DietPlanClass dietPlan) {
          if (dietPlan.id == id) {
            dietPlan.isChecked = !dietPlan.isChecked;
            return dietPlan;
          }

          return dietPlan;
        }).toList();
      });
    }

    onButtonEnabled() {
      return getCheckList().isNotEmpty;
    }

    onPressedOk({text, iconData}) {
      DietPlanClass dietPlan = DietPlanClass(
        id: const Uuid().v4(),
        icon: iconData,
        plan: text,
        isChecked: true,
        isAction: false,
      );

      setState(() {
        dietPlanList.add(dietPlan);
        showTouchArea = true;
      });

      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }

    onPressedCancel() {
      setState(() => showTouchArea = true);
    }

    var dietPlanListView = dietPlanList
        .map((DietPlanClass dietPlan) => AddDietPlanCheck(
              id: dietPlan.id,
              icon: dietPlan.icon,
              text: dietPlan.plan,
              isChecked: dietPlan.isChecked,
              onTapCheck: onTapCheck,
            ))
        .toList();

    return AddContainer(
      body: SingleChildScrollView(
        child: Column(children: [
          SimpleStepper(currentStep: 3),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '오늘의 다이어트 계획을 구성해보세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            height: 345,
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentsTitleText(
                  text: '오늘의 다이어트 계획',
                  sub: [
                    SubText(
                      text: '체크',
                      value: getCheckList().length.toString(),
                    )
                  ],
                ),
                SpaceHeight(height: smallSpace),
                ScrollbarListView(
                  controller: scrollController,
                  dataList: dietPlanListView,
                ),
                SpaceHeight(height: tinySpace),
                TouchAndCheckInputWidget(
                  showEmptyTouchArea: showTouchArea,
                  checkBoxEnabledIcon: Icons.check_box_outlined,
                  checkBoxDisEnabledIcon: Icons.check_box_outline_blank_rounded,
                  onTapEmptyArea: onTapEmptyArea,
                  onPressedOk: onPressedOk,
                  onPressedCancel: onPressedCancel,
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomSubmitButtonText: '완료',
      buttonEnabled: onButtonEnabled(),
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
      actions: [],
    );
  }
}
