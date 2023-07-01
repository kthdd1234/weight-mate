import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:provider/provider.dart';

class nameTextInput extends StatefulWidget {
  nameTextInput({
    super.key,
    required this.name,
    required this.onCounterText,
    required this.onChanged,
  });

  String name;
  Function() onCounterText;
  Function(String str) onChanged;

  @override
  State<nameTextInput> createState() => _nameTextInputState();
}

class _nameTextInputState extends State<nameTextInput> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsTitleText(text: '이름'),
        SpaceHeight(height: smallSpace),
        TextInput(
          controller: nameController,
          autofocus: true,
          maxLength: 20,
          prefixIcon: Icons.edit,
          suffixText: '',
          hintText: '이름을 입력해주세요.',
          counterText: null,
          helperText: widget.onCounterText(),
          onChanged: widget.onChanged,
          errorText: null,
          keyboardType: TextInputType.text,
        )
      ],
    );
  }
}
