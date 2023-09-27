// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:f_web_authentication/ui/controller/authentication_controller.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/authentication/signup.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.put(Repository());
    Get.put(AuthenticationUseCase());
    Get.put(AuthenticationController());
    Get.put(CalculatorController());
  });
  // Login Test
  testWidgets('Login page should render correctly',
      (WidgetTester tester) async {
    //

    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    expect(find.text('Login with email'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });
  testWidgets('Login successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(const Key('TextFieldLEmail'));
    final passwordField = find.byKey(const Key('TextFieldLPassword'));

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '123456');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);

    // Pump the widget to update the UI
    await tester.pumpAndSettle();

    // Expect the login to be successful and the home page to be rendered
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Email missing @', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(const Key('TextFieldLEmail'));
    final passwordField = find.byKey(const Key('TextFieldLPassword'));

    await tester.enterText(emailField, 'aa.com');
    await tester.enterText(passwordField, '123456');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter valid email address"), findsOneWidget);
  });

  testWidgets('Email Empty', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(const Key('TextFieldLEmail'));
    final passwordField = find.byKey(const Key('TextFieldLPassword'));

    await tester.enterText(emailField, '');
    await tester.enterText(passwordField, '123456');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter email"), findsOneWidget);
  });

  testWidgets('Password', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(const Key('TextFieldLEmail'));
    final passwordField = find.byKey(const Key('TextFieldLPassword'));

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter password"), findsOneWidget);
  });

  testWidgets('Password', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(const Key('TextFieldLEmail'));
    final passwordField = find.byKey(const Key('TextFieldLPassword'));

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '1');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Password should have at least 6 characters"),
        findsOneWidget);
  });

//Sign up test
  testWidgets('Signup is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUp()));

    final emailKey = find.byKey(const Key("SEK"));
    final passKey = find.byKey(const Key("SPK"));
    final fnkey = find.byKey(const Key("FNK"));
    final lnkey = find.byKey(const Key("LNK"));
    final schoolkey = find.byKey(const Key("SK"));
    final gradekey = find.byKey(const Key("GK"));

    await tester.enterText(emailKey, '');
    await tester.enterText(passKey, '');
    await tester.enterText(fnkey, '');
    await tester.enterText(lnkey, '');
    await tester.enterText(schoolkey, '');
    await tester.enterText(gradekey, '');

    final loginButton = find.byKey(const Key("SubK"));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter email"), findsOneWidget);
    expect(find.text("Enter password"), findsOneWidget);
    expect(find.text("Enter name"), findsOneWidget);
    expect(find.text("Enter last name"), findsOneWidget);
    expect(find.text("Enter School"), findsOneWidget);
    expect(find.text("Enter Grade"), findsOneWidget);
  });

  testWidgets('Error in SignUp', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUp()));

    final emailKey = find.byKey(const Key("SEK"));
    final passKey = find.byKey(const Key("SPK"));

    await tester.enterText(emailKey, 'aa.com');
    await tester.enterText(passKey, '1');

    final loginButton = find.byKey(const Key("SubK"));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter valid email address"), findsOneWidget);
    expect(find.text("Password should have at least 6 characters"),
        findsOneWidget);
  });

  //Calculator test
  testWidgets('Testing Homepage', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: HomePage()));

    final uB = find.byKey(const Key("ButtonHomeUsser"));
    await tester.tap(uB);

    await tester.pumpAndSettle();
    expect(find.text('Datos de Usuario'), findsOneWidget);
  });
}
