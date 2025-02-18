// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/authentication/signup.dart';
import 'package:f_web_authentication/ui/pages/content/calculator_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:f_web_authentication/ui/pages/content/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:f_web_authentication/main.dart';

import '../test/fake_local_datasource.dart';
import '../test/fake_user_datasource.dart';

Future<MyApp> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();

  return const MyApp();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.put(UserRepository(FakeUserDataSource()));
    Get.put(LocalRepository(dataSource: FakeLocalDataSource()));
    Get.put(UserUseCase());
    Get.put(CalculatorController());
  });

  testWidgets("App works", (tester) async {
    final app = await createHomeScreen();
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final signUpButton = find.byKey(LoginPage.CREATE_BUTTON);

    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    final emailField = find.byKey(SignUp.EMAIL);
    final submitButton = find.byKey(SignUp.SUBMIT);
    const email = "user@email.com";

    await tester.enterText(emailField, email);
    await tester.pump();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    final homeText = find.text("Hello $email");
    expect(homeText, findsOneWidget);

    final logoutButton = find.byKey(HomePage.LOGOUT);

    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    final emailLoginField = find.byKey(LoginPage.EMAIL);
    final loginSubmitButton = find.byKey(LoginPage.SUBMIT);

    await tester.enterText(emailLoginField, email);
    await tester.pump();
    await tester.tap(loginSubmitButton);
    await tester.pumpAndSettle();

    expect(find.text("Hello $email"), findsOneWidget);

    final startButton = find.byKey(HomePage.START);

    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.text("Game"), findsOneWidget);

    final goButton = find.byKey(CalculatorPage.GO);

    for (int i = 0; i < 6; i++) {
      await tester.tap(goButton);
      await tester.pumpAndSettle();
    }

    expect(find.text("Session Summary"), findsOneWidget);

    final continueButton = find.byKey(SummaryPage.CONTINUE);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    final historyButton = find.byKey(HomePage.HISTORY);

    await tester.tap(historyButton);
    await tester.pumpAndSettle();

    expect(find.text("History"), findsOneWidget);

    final logoutButton2 = find.byKey(HomePage.LOGOUT);

    await tester.tap(logoutButton2);
    await tester.pumpAndSettle();
  });
}
