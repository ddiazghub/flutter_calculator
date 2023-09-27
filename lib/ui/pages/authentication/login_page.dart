import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../controller/authentication_controller.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const CREATE_BUTTON = Key("CreateAccountButton");
  static const EMAIL = Key("LoginEmailField");
  static const SUBMIT = Key("LoginSubmitField");

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: 'a@a.com');
  final controllerPassword = TextEditingController(text: '123456');
  AuthenticationController authenticationController = Get.find();

  Future<void> _login(String theEmail, String thePassword) async {
    logInfo('_login $theEmail $thePassword');
    try {
      await authenticationController.login(Credentials(theEmail, thePassword));
    } catch (err) {
      Get.snackbar(
        "Login",
        err.toString(),
        icon: const Icon(Icons.person, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login with email",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: LoginPage.EMAIL,
                    keyboardType: TextInputType.emailAddress,
                    controller: controllerEmail,
                    decoration:
                        const InputDecoration(labelText: "Email address"),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Enter email";
                      } else if (!value.contains('@')) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: controllerPassword,
                    decoration: const InputDecoration(labelText: "Password"),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Enter password";
                      } else if (value.length < 6) {
                        return "Password should have at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    key: LoginPage.SUBMIT,
                    onPressed: () async {
                      // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
                      FocusScope.of(context).requestFocus(FocusNode());
                      final form = _formKey.currentState;
                      form!.save();
                      if (_formKey.currentState!.validate()) {
                        await _login(
                          controllerEmail.text,
                          controllerPassword.text,
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
            TextButton(
              key: LoginPage.CREATE_BUTTON,
              onPressed: () => Get.to(() => const SignUp()),
              child: const Text("Create account"),
            )
          ],
        ),
      ),
    );
  }
}
