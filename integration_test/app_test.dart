// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/helpers.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/authentication/signup.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:f_web_authentication/main.dart';

Future<MyApp> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();

  return const MyApp();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.put(UserRepository("http://192.168.1.8:8000"));
    Get.put(LocalRepository());
    Get.put(UserUseCase());
    Get.put(CalculatorController());
  });

  testWidgets("App works", (tester) async {
    final app = await createHomeScreen();
    await tester.pumpWidget(app);

    final signUpButton = find.byKey(LoginPage.CREATE_BUTTON);

    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    final emailField = find.byKey(SignUp.EMAIL);
    final submitButton = find.byKey(SignUp.SUBMIT);
    final username = randomHexString(32);
    final email = "$username@email.com";

    await tester.enterText(emailField, email);
    await tester.pump();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    final homeText = find.text("Hello $email");
    expect(homeText, findsAtLeastNWidgets(1));

    final logoutButton = find.byKey(HomePage.LOGOUT);

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    final emailLoginField = find.byKey(LoginPage.EMAIL);
    final loginSubmitButton = find.byKey(LoginPage.SUBMIT);

    await tester.enterText(emailLoginField, email);
    await tester.pump();
    await tester.tap(loginSubmitButton);
    await tester.pumpAndSettle();

    final homeText2 = find.text("Hello $email");

    expect(homeText2, findsAtLeastNWidgets(1));
  });
}
