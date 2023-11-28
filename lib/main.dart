import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:week10_1109/screen/home_screen.dart';
import 'package:week10_1109/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:week10_1109/provider/schedule_provider.dart';
import 'package:week10_1109/repository/schedule_repository.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:week10_1109/firebase_options.dart';

// Node.js 사용 버전

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 프로젝트 설정 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();
  
  // final database = LocalDatabase();
  // GetIt.I.registerSingleton<LocalDatabase>(database);
  // GetIt : 의존성 주입을 구현하는 플러그인, database를 프로젝트 전역에서 사용하려면 서브 위젯으로 값을 계속 넘겨줘야 하는데 반복적인 코드를 너무 많이 사용함
  // GetIt으로 값을 한 번 등록해두면 어디서든 처음에 주입한 값으로 프로젝트 어디서든 사용 가능

  // final repository = ScheduleRepository();
  // final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    // ChangeNotifierProvider(
    //   create: (_) => scheduleProvider,
    //   child: MaterialApp(
    //     home: HomeScreen(),
    //   ),
    // ),
     MaterialApp(
       debugShowCheckedModeBanner: false,
       home: HomeScreen(),
     ),
  );

}