import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Miptgram/screens/onboding/onboding_screen.dart';
import 'package:Miptgram/screens/entryPoint/entry_point.dart';
import 'package:Miptgram/screens/schedule/schedule_entry.dart';
import 'package:Miptgram/screens/confessions/confessions_entry.dart';
import 'package:Miptgram/pages/ChatPage.dart';
import 'package:Miptgram/pages/HomeChat.dart';
import 'package:Miptgram/pages/chat_entry.dart';
import 'package:Miptgram/pages/dialog_entry.dart';

/*
  TODO:
  - ADD ICONS FOR APP
  - SCHEDULE
  - !!!Flutter Local Notifications!!!! - запланированные дела (локальные push уведомления)
  - SIGN UP func
  - MESSENGER

*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
  // await prefs.setInt('counter', 10); // dump data by key
  // setBool, setDouble, setString, setStringList

  // await prefs.getInt('counter', 10); // load data by key
  // getBool, getDouble, getString, getStringList

  // await prefs.containsKey('counter'); // check data by key

  // await prefs.remove('counter'); // remove data by key

  // await prefs.clear(); // remove all data
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({required this.prefs});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miptgram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      initialRoute: _decideMainPage(),
      routes: {
        '/': (context) => OnbodingScreen(prefs: prefs),
        '/entry': (context) => EntryPoint(prefs: prefs),
        '/confessions': (context) => EntryPointConf(prefs: prefs),
        '/schedule': (context) => EntryPointSched(prefs: prefs),
        '/homechat': (context) => EntryPointChat(prefs: prefs),
        '/chatPage': (context) => ChatPage(prefs: prefs),
      },
    );
  }

  _decideMainPage() {
    if (prefs.getBool('is_verified') != null) {
      if (prefs.getBool('is_verified')!) {
        return '/entry'; // Main page
      } else {
        return '/'; // Auth page
      }
    } else {
      return '/'; // Auth page
    }
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
