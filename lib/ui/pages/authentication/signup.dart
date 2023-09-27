import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/ui/central.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../controller/authentication_controller.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _FirebaseSignUpState();
}

class _FirebaseSignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final controllerFirstName = TextEditingController(text: 'pepito');
  final controllerLastName = TextEditingController(text: 'perez');
  final controllerEmail = TextEditingController(text: 'a@a.com');
  final controllerPassword = TextEditingController(text: '123456');
  final controllerSchool = TextEditingController(text: 'Royal school');
  final controllerGrade = TextEditingController(text: '11');
  final controllerBirth = TextEditingController(text: '2000-1-1');
  AuthenticationController authenticationController = Get.find();

  final emailKey = const Key("SEK");
  final passKey = const Key("SPK");
  final fnkey = const Key("FNK");
  final lnkey = const Key("LNK");
  final schoolkey = const Key("SK");
  final gradekey = const Key("GK");
  final birthkey = const Key("BK");
  final subkey = const Key("SubK");

  Future<void> _signup(User user, String password) async {
    //try {
    await authenticationController.signUp(user, password);
    Get.off(() => const Central());
    //} catch (err) {
    //  logError('SignUp error $err');
    //  Get.snackbar(
    //    "Sign Up",
    //    err.toString(),
    //    icon: const Icon(Icons.person, color: Colors.red),
    //    snackPosition: SnackPosition.BOTTOM,
    //  );
    //}
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controllerBirth.text = formattedDate
            .toString(); // Store the selected date in the controller
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign Up Information",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: emailKey,
                            keyboardType: TextInputType.emailAddress,
                            controller: controllerEmail,
                            decoration: const InputDecoration(
                                labelText: "Email address"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                logError('SignUp validation empty email');
                                return "Enter email";
                              } else if (!value.contains('@')) {
                                logError('SignUp validation invalid email');
                                return "Enter valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: passKey,
                            controller: controllerPassword,
                            decoration:
                                const InputDecoration(labelText: "Password"),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter password";
                              } else if (value.length < 6) {
                                return "Password should have at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: fnkey,
                            controller: controllerFirstName,
                            decoration:
                                const InputDecoration(labelText: "First Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                logError('SignUp validation empty first name');
                                return "Enter name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: lnkey,
                            controller: controllerLastName,
                            decoration:
                                const InputDecoration(labelText: "Last Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                logError('SignUp validation empty last name');
                                return "Enter last name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: schoolkey,
                            controller: controllerSchool,
                            decoration:
                                const InputDecoration(labelText: "School"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                logError('SignUp validation empty School');
                                return "Enter School";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: gradekey,
                            controller: controllerGrade,
                            decoration:
                                const InputDecoration(labelText: "Grade"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                logError('SignUp validation empty Grade');
                                return "Enter Grade";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: birthkey,
                            controller: controllerBirth,
                            decoration: InputDecoration(
                              labelText: 'Select a date',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(
                                context), // Open the date picker when the field is tapped
                          ),
                          TextButton(
                              key: subkey,
                              onPressed: () async {
                                final form = _formKey.currentState;
                                form!.save();
                                // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_formKey.currentState!.validate()) {
                                  logInfo('SignUp validation form ok');

                                  final user = User(
                                    controllerEmail.text,
                                    controllerFirstName.text,
                                    controllerLastName.text,
                                    controllerBirth.text,
                                    controllerSchool.text,
                                    controllerGrade.text,
                                    0,
                                  );

                                  await _signup(user, controllerPassword.text);
                                } else {
                                  logError('SignUp validation form nok');
                                }
                              },
                              child: const Text("Submit")),
                        ]),
                  ),
                ))));
  }
}
