import 'package:flutter/material.dart';
import '../const/colors.dart';
import 'custom_text_field.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:get_it/get_it.dart';
import 'package:week10_1109/database/drift_database.dart';
import 'package:week10_1109/model/schedule_model.dart';
// import 'package:provider/provider.dart';
// import 'package:week10_1109/provider/schedule_provider.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleBottomSheet extends StatefulWidget{
  final DateTime selectedDate;
  const ScheduleBottomSheet ({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context){
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 아래서 올라오는 키보드 높이
    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height/2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top:8, bottom: bottomInset),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작시간',
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: '종료시간',
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context), // 함수에 context 전달
                    style: ElevatedButton.styleFrom(
                      primary: PRIMARY_COLOR,
                    ),
                    child: Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void onSavePressed(BuildContext context) async {
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // 스케줄 모델 생성하기
      final schedule = ScheduleModel(
        id: Uuid().v4(),
        content: content!,
        date: widget.selectedDate,
        startTime: startTime!,
        endTime: endTime!,
      );

      // 스케줄 모델 파이어스토어에 삽입하기
      await FirebaseFirestore.instance.collection(
        'schedule',
      ).doc(schedule.id).set(schedule.toJson());



      // await GetIt.I<LocalDatabase>().createSchedule(
      //   SchedulesCompanion(
      //     startTime: Value(startTime!),
      //     endTime: Value(endTime!),
      //     content: Value(content!),
      //     date: Value(widget.selectedDate),
      //   ),
      // );

      // context.read<ScheduleProvider>().createSchedule(
      //     schedule: ScheduleModel(
      //         id: 'new_model',
      //         content: content!,
      //         date: widget.selectedDate,
      //         startTime: startTime!,
      //         endTime: endTime!,
      //     ),
      // );

      Navigator.of(context).pop();
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try{
      number = int.parse(val);
    } catch(e) {
      return '숫자를 입력해주세요';
    }

    if(number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  }

  String? contentValidator(String? val) {
    if(val == null || val.length == 0) {
      return '값을 입력해주세요';
    }

    return null;
  }


}