import 'package:f_web_authentication/ui/central.dart';
import 'package:f_web_authentication/ui/controller/user_controller.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'domain/repositories/repository.dart';
import 'domain/use_case/authentication_usecase.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  Get.put(UserRepository("http://10.250.181.123:8000"));
  Get.put(UserUseCase());
  Get.put(UserController());
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
        primarySwatch: Colors.blue,
      ),
      home: const Central(),
    );
  }
}
