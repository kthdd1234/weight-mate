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
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
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
  late Box<UserInfoBox> userInfoBox;

  List<DietPlanClass> dietPlanList = [];
  bool showTouchArea = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    dietPlanList = defaultDietPlanList;
    userInfoBox = Hive.box<UserInfoBox>('userInfoBox');
  }

  @override
  Widget build(BuildContext context) {
    getCheckList() {
      return dietPlanList.where((dietPlan) => dietPlan.isChecked).toList();
    }

    onPressedBottomNavigationButton() {
      final checkList = getCheckList();

      if (checkList.isNotEmpty) {
        context.read<DietInfoProvider>().changeDietPlanList(checkList);

        final provider = context.read<DietInfoProvider>();
        final userInfoState = provider.getUserInfo();
        final recordInfoData = provider.getRecordInfoData();

        userInfoBox.put(
          'userInfo',
          UserInfoBox(
            tall: userInfoState.tall,
            goalWeight: userInfoState.goalWeight,
            startDietDateTime: userInfoState.startDietDateTime,
            endDietDateTime: userInfoState.endDietDateTime,
            recordStartDateTime: DateTime.now(),
            recordInfoList: [recordInfoData],
          ),
        );

        context
            .read<RecordSelectedDateTimeProvider>()
            .setSelectedDateTime(DateTime.now());

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-container',
          (_) => false,
        );
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
          HeadlineText(text: '목표 체중을 달성하기 위한'),
          SpaceHeight(height: tinySpace),
          HeadlineText(text: '나만의 계획을 구성해보세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            height: 345,
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentsTitleText(
                  text: '나만의 계획',
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
