import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:f_web_authentication/ui/central.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'domain/repositories/repository.dart';
import 'domain/use_case/user_usecase.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  Get.put(UserRepository.remote( "http://192.168.1.3:8000"));
  Get.put(LocalRepository());
  Get.put(UserUseCase());
  Get.put(CalculatorController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const Central(),
    );
  }
}
