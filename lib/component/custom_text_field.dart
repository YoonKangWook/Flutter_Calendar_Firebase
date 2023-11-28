import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/colors.dart';


class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;  // 시간 입력용인지 판단
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null, // null 여러줄 입력 가능
            expands: !isTime,
            keyboardType: isTime ? TextInputType.number: TextInputType.multiline,
            inputFormatters: isTime ? [
              FilteringTextInputFormatter.digitsOnly, // 숫자만 입력하도록 제한
            ] : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isTime ? '시' : null, // 시간 관련 텍스트에 접미사 '시'추가
            ),
          ),
        ),
      ],

    );
  }

}