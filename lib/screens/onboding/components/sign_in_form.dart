import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:Miptgram/screens/entryPoint/entry_point.dart';
import 'package:postgres/postgres.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  final SharedPreferences prefs;
  SignInForm({required this.prefs});

  @override
  State<SignInForm> createState() => _SignInFormState(prefs: prefs);
}

class _SignInFormState extends State<SignInForm> {
  final SharedPreferences prefs;
  _SignInFormState({required this.prefs});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  String generateMd5(String input) =>
      md5.convert(utf8.encode(input + 'kisy lubish')).toString();

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  Future<void> PostgresFuture() async {
    String email = email_controller.text;
    String password = password_controller.text;
    print(email_controller.text);
    print(password_controller.text);
    final conn = PostgreSQLConnection(
      'your-ip',
      your - port,
      'your-db',
      username: 'your-username',
      password: '<your-password>',
      useSSL: true,
    );
    if (_formKey.currentState!.validate()) {
      print('if validate clause');
      await conn.open();
      print(email);
      try {
        dynamic results, account;
        var name, surname, groupname;

        try {
          results = await conn.query('''SELECT password FROM users 
          WHERE email = @email;''', substitutionValues: {'email': email});
          account = await conn.query('''SELECT name, surname, group_name 
          FROM users JOIN groups USING(group_id) 
          WHERE email=@email;''', substitutionValues: {'email': email});
          if (account.length > 0) {
            name = account[0][0];
            surname = account[0][1];
            groupname = account[0][2];
          } else {
            name = "";
            surname = "";
            groupname = "";
          }
        } on Exception catch (e, s) {
          results = [];
          account = [];
          name = "";
          surname = "";
          groupname = "";
        }

        bool flag = false;
        String hash = generateMd5(password);

        for (var row in results) {
          if (row[0] == hash) {
            flag = true;
          }
        }
        if (flag) {
          print('authorised');
          success.fire();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });

            confetti.fire();
            Future.delayed(const Duration(seconds: 1), () {
              // Navigator.pop(context);
              prefs.setBool('is_verified', true);
              prefs
                  .setStringList('account', <String>[name, surname, groupname]);
              prefs.setBool('is_verified', true);

              Navigator.pushNamedAndRemoveUntil(
                  context, '/entry', (route) => false);
            });
          });
        } else {
          print('unauthorised');
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();
            },
          );
        }
      } finally {
        await conn.close();
      }
    } else {
      print('else validate clause');
      error.fire();
      print('after error fire');
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            isShowLoading = false;
          });
          reset.fire();
        },
      );
    }
  }

  void UsePostgresFuture() {
    PostgresFuture().catchError((e) => print('It"s error:$e'));
  }

  void signInTest(BuildContext context) {
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    print('After setter, loading:$isShowLoading');
    print('After setter, confeti:$isShowConfetti');

    Future.delayed(const Duration(seconds: 1), () {
      UsePostgresFuture();
    });
  }

  void signIn(BuildContext context, {required prefs}) {
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    var email = email_controller.text;
    var password = password_controller.text;
    print(email_controller.text);
    print(password_controller.text);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          print('if clause');
          success.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              confetti.fire();
              // Navigate & hide confetti
              Future.delayed(const Duration(seconds: 1), () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryPoint(prefs: prefs),
                  ),
                );
              });
            },
          );
        } else {
          print('else validate clause');
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email_controller,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Введите действительную почту';
                    }
                    if (email_controller.text.contains('@phystech.edu') ||
                        email_controller.text.contains('@mipt.ru')) {
                      return null;
                    }
                    return "Введите почту в домене @mipt.ru или @phystech.edu";
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  controller: password_controller,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Пароль должен содержать минимум 8 символов";
                    }
                    if (value.length > 7) {
                      return null;
                    }
                    return "Пароль должен содержать минимум 8 символов";
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    signInTest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Sign In"),
                ),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
