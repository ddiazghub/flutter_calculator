// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/main.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/authentication/signup.dart';
import 'package:f_web_authentication/ui/pages/content/calculator_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'fake_local_datasource.dart';
import 'fake_user_datasource.dart';

void main() {
  setUp(() {
    Get.put(UserRepository(FakeUserDataSource()));
    Get.put(LocalRepository(dataSource: FakeLocalDataSource()));
    Get.put(UserUseCase());
    Get.put(CalculatorController());
  });

  // Login Test
  testWidgets('Login page should render correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    expect(find.text('Login with email'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('SignUp and Login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final signUpButton = find.byKey(LoginPage.CREATE_BUTTON);

    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    var emailField = find.byKey(SignUp.EMAIL);
    final submitButton = find.byKey(SignUp.SUBMIT);
    const email = "user@email.com";

    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    final auth = Get.find<UserUseCase>();

    // await auth.signUp(
    //   User(
    //     'test33@example.com',
    //     'John',
    //     'Doe',
    //     '2000-01-01',
    //     'Test School',
    //     '12',
    //     0,
    //     [],
    //     DateTime.now(),
    //   ),
    //   "123456",
    // );

    print("Logged: ${auth.isLoggedIn}");

    // Expect the signUp to be successful and the home page to be rendered;
    expect(find.byType(HomePage), findsOneWidget);

    auth.logOut();
    emailField = find.byKey(LoginPage.EMAIL);

    await tester.enterText(emailField, email);

    final loginButton = find.byKey(LoginPage.SUBMIT);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Expect the login to be successful and the home page to be rendered
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Email missing @', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(LoginPage.EMAIL);
    final passwordField = find.byKey(LoginPage.PASSWORD);

    await tester.enterText(emailField, 'aa.com');
    await tester.enterText(passwordField, '123456');

    final loginButton = find.byKey(LoginPage.SUBMIT);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text("Enter valid email address"), findsOneWidget);
  });

  testWidgets('Email Empty', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(LoginPage.EMAIL);
    final passwordField = find.byKey(LoginPage.PASSWORD);

    await tester.enterText(emailField, '');
    await tester.enterText(passwordField, '123456');

    final loginButton = find.byKey(const Key('LoginSubmitField'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Enter email"), findsOneWidget);
  });

  testWidgets('Password', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(LoginPage.EMAIL);
    final passwordField = find.byKey(LoginPage.PASSWORD);

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '');

    final loginButton = find.byKey(const Key('ButtonLoginSubmit'));

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text("Enter password"), findsOneWidget);
  });

  testWidgets('Password', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    final emailField = find.byKey(LoginPage.EMAIL);
    final passwordField = find.byKey(LoginPage.PASSWORD);

    await tester.enterText(emailField, 'a@a.com');
    await tester.enterText(passwordField, '1');

    final loginButton = find.byKey(const Key('LoginSubmitField'));

    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    expect(find.text("Password should have at least 6 characters"),
        findsOneWidget);
  });

  //Sign up test
  testWidgets('Signup is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUp()));

    final emailKey = find.byKey(SignUp.EMAIL);
    final passKey = find.byKey(SignUp.PASSWORD);
    final fnkey = find.byKey(SignUp.FIRST_NAME);
    final lnkey = find.byKey(SignUp.LAST_NAME);
    final schoolkey = find.byKey(SignUp.SCHOOL);
    final gradekey = find.byKey(SignUp.GRADE);

    await tester.enterText(emailKey, '');
    await tester.enterText(passKey, '');
    await tester.enterText(fnkey, '');
    await tester.enterText(lnkey, '');
    await tester.enterText(schoolkey, '');
    await tester.enterText(gradekey, '');

    final loginButton = find.byKey(SignUp.SUBMIT);

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

    final emailKey = find.byKey(SignUp.EMAIL);
    final passKey = find.byKey(SignUp.PASSWORD);

    await tester.enterText(emailKey, 'aa.com');
    await tester.enterText(passKey, '1');

    final loginButton = find.byKey(SignUp.SUBMIT);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text("Enter valid email address"), findsOneWidget);
    expect(find.text("Password should have at least 6 characters"),
        findsOneWidget);
  });

  //Calculator test
  testWidgets('Testing Homepage', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: HomePage()));

    final uB = find.byKey(HomePage.USER);

    await tester.tap(uB);
    await tester.pumpAndSettle();

    expect(find.text('Datos de Usuario'), findsOneWidget);
  });

  testWidgets('Testing Buttons', (WidgetTester tester) async {
    final auth = Get.find<UserUseCase>();

    await auth.login(
      Credentials("test@example.com", "123456"),
    );

    await tester.pumpWidget(GetMaterialApp(
        home: SingleChildScrollView(
      child: SizedBox(
        width: 1000,
        height: 1000,
        child: CalculatorPage(),
      ),
    )));
    await tester.pumpAndSettle();
    final button = find.byKey(
      const Key("b1"),
    );
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text("1"), findsAtLeastNWidgets(1));
  });
}
