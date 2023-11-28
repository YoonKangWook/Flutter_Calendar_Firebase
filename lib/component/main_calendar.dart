import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/colors.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  const MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
        date.year == selectedDate.year&&
        date.month == selectedDate.month&&
        date.day == selectedDate.day,

      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(2200, 12, 31),
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle( // ➊ 달력 최상단 스타일
        titleCentered: true, // 제목 중앙에 위치하기
        formatButtonVisible: false, // 달력 크기 선택 옵션 없애기
        titleTextStyle: TextStyle( // 제목 글꼴
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        defaultDecoration: BoxDecoration( // ➋ 기본 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration( // ➌ 주말 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        selectedDecoration: BoxDecoration( // ➍ 선택된 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle( // ➎ 기본 글꼴
          fontWeight: FontWeight.w600, color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle( // ➏ 주말 글꼴
          fontWeight: FontWeight.w600, color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: TextStyle( // ➐ 선택된 날짜 글꼴
          fontWeight: FontWeight.w600, color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
