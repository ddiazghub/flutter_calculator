import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/components/history_item.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  static const LOGOUT = Key("ButtonHistoryLogOff");
  static const USER = Key("ButtonHistoryUser");

  final UserUseCase useCase = Get.find();

  @override
  Widget build(BuildContext context) {
    final history = useCase.user!.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            key: LOGOUT,
            onPressed: () async {
              await useCase.logOut();
              await Get.offAll(() => const LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            key: USER,
            onPressed: () => HomePage.showPopup(context, useCase.user!),
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) =>
            HistoryItem(title: "Session ${index + 1}", record: history[index]),
      ),
    );
  }
}
