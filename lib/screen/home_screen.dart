import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week10_1109/component/main_calendar.dart';
import 'package:week10_1109/component/schedule_card.dart';
import 'package:week10_1109/component/today_banner.dart';
import 'package:week10_1109/component/schedule_bottom_sheet.dart';
import '../const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:week10_1109/database/drift_database.dart';
import 'package:provider/provider.dart'; // Provider 불러오기
import 'package:week10_1109/provider/schedule_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/schedule_model.dart';

// class HomeScreen extends StatefulWidget{
//   const HomeScreen ({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {

// class HomeScreen extends StatelessWidget { // 프로바이더로 상태(데이터) 관리, 메모리 많이 차지하는 StatefulWidget 사용 안함

class HomeScreen extends StatefulWidget {
  // Provider 사용하지 않으면서 다시 StatefulWidget으로 변경함
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  
  // 선택된 날짜를 관리할 변수
 DateTime selectedDate = DateTime.utc(
   DateTime.now().year,
   DateTime.now().month,
   DateTime.now().day,
 );

  @override
  Widget build(BuildContext context){

    // // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    // final provider = context.watch<ScheduleProvider>();
    //
    // // 선택된 날짜 가져오기
    // final selectedDate = provider.selectedDate;
    //
    // // 선택된 날짜에 해당되는 일정들 가져오기
    // final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              builder: (_) => ScheduleBottomSheet(
                selectedDate: selectedDate,
              ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,

              // 날짜 선택 시 실행되는 함수
              onDaySelected: (selectedDate, focusedDate) => onDaySelected(selectedDate, focusedDate, context),

            ),
            SizedBox(height: 8.0),

            // StreamBuilder<List<Schedule>>(
            //   stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            //   builder: (context, snapshot) {
            //     return TodayBanner(
            //       selectedDate: selectedDate,
            //       count: snapshot.data?.length ?? 0,
            //     );
            //   }
            // ),

            // StreamBuilder로 TodayBanner 감싸기
            StreamBuilder<QuerySnapshot>(

              // ListView에 적용했던 것과 같은 쿼리
              stream: FirebaseFirestore.instance.collection(
                'schedule',
              ).where(
                'date',
                isEqualTo:
                  '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
              ).snapshots(),
              builder: (context, snapshot){
                return TodayBanner(selectedDate: selectedDate, count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),

            SizedBox(height: 8.0),

            // Expanded(
            //   child: StreamBuilder<List<Schedule>>(
            //     stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            //     builder: (context, snapshot) {
            //       if(!snapshot.hasData){
            //         return Container();
            //       }
            //       return ListView.builder(
            //         itemCount: snapshot.data!.length,
            //         itemBuilder: (context, index) {
            //            final schedule = snapshot.data![index];
            //            return Dismissible(
            //              key: ObjectKey(schedule.id),
            //              direction: DismissDirection.startToEnd,
            //              onDismissed: (DismissDirection direction){
            //                GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
            //              },
            //              child: Padding(
            //                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            //                child: ScheduleCard(
            //                  startTime: schedule.startTime,
            //                  endTime: schedule.endTime,
            //                  content: schedule.content,
            //                ),
            //              ),
            //            );
            //         },
            //       );
            //     }
            //   ),
            // ),
            Expanded(
              // StreamBuilder 구현하기
              child: StreamBuilder<QuerySnapshot>(
                
                // 파이어스토어로부터 일정 정보 받아오기
                stream: FirebaseFirestore.instance.collection(
                  'schedule',
                ).where(
                  'date',
                  isEqualTo: 
                    '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
                ).snapshots(),
                builder: (context, snapshot){
                  
                  // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }
                  
                  // 로딩 중일 때 보여줄 화면
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  
                 // ScheduleModel로 데이터 매핑하기
                 final schedules = snapshot.data!.docs.map((QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                   json: (e.data() as Map<String, dynamic>)),
                 ).toList();
                  
                 return ListView.builder(
                   itemCount: schedules.length,
                   itemBuilder: (context, index){
                     final schedule = schedules[index];
                     
                     return Dismissible(
                       key: ObjectKey(schedule.id),
                       direction: DismissDirection.startToEnd,
                       onDismissed: (DismissDirection direction) {

                         // 특정 문서 삭제하기
                         FirebaseFirestore.instance.collection('schedule').doc(schedule.id).delete();
                         
                       },
                     child: Padding(
                       padding: const EdgeInsets.only(
                           bottom: 8.0, left: 8.0, right: 8.0),
                       child: ScheduleCard(
                         startTime: schedule.startTime,
                         endTime: schedule.endTime,
                         content: schedule.content,
                       ),
                     ),
                     );
                   },
                 );
                  
                },
              ),
            ),

            // Provider 관련 코드 사용시 주석 해제
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: schedules.length,
            //     itemBuilder: (context, index) {
            //       final schedule = schedules[index];
            //
            //       return Dismissible(
            //           key: ObjectKey(schedule.id),
            //           direction: DismissDirection.startToEnd,
            //           onDismissed: (DismissDirection direction) {
            //             provider.deleteSchedule(date: selectedDate, id: schedule.id); // drift에서 ScheduleProvider에 정의한 삭제 작업으로 대체함
            //           },
            //         child: Padding(
            //           padding: const EdgeInsets.only(
            //             bottom: 8.0, left: 8.0, right: 8.0),
            //           child: ScheduleCard(
            //             startTime: schedule.startTime,
            //             endTime: schedule.endTime,
            //             content: schedule.content,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),


          ],
        ),
      ),


    );
  }

  // void onDaySelected(DateTime selectedDate, DateTime focusedDate){
  //   setState(() {
  //     this.selectedDate = selectedDate;
  //   });
  // }

  void onDaySelected(
      DateTime selectedDate,
      DateTime focuseDate,
      BuildContext context,
      ) {
    
    // 새로운 날짜가 선택될 때마다 selectDate값 변경해주기
    setState(() {
      this.selectedDate = selectedDate;
    });
    
    //// provider 관련 코드 삭제
    // final provider = context.read<ScheduleProvider>();
    // provider.changeSelectDate(date: selectedDate,
    // );
    // provider.getSchedules(date: selectedDate);
    
    
  }

}