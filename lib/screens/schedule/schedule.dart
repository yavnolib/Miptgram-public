import 'package:flutter/material.dart';
import 'schedule_day.dart';
import 'package:postgres/postgres.dart';
import 'package:Miptgram/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends StatelessWidget {
  final SharedPreferences prefs;
  Schedule({super.key, required this.prefs});

  static const String _title = 'Тайминг';
  static const orange = Color.fromARGB(255, 255, 163, 26);
  static const fontFamily = 'Roboto';

  @override
  Widget build(BuildContext context) {
    return ScheduleController(
      prefs: prefs,
    );
  }
}

Future<PostgreSQLResult> get_sched_by_name_surname(name, surname) async {
  final conn = PostgreSQLConnection(
    'your-ip',
    your - port,
    'your-db',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );

  await conn.open();
  final results = await conn.query(
      '''SELECT subject_name, weekday_name, pair_name FROM schedule JOIN users USING(uid)
      JOIN weekdays USING(weekday_id) JOIN pairs USING(pair_id) JOIN subjects USING(subject_id) WHERE (name = '$name') and (surname = '$surname') ORDER BY pair_id;''');
  // PostgreSQLResult - "list" of PostgreSQLResultRow

  // var cast_result = results.asMap();
  // print(cast_result);
  // print(cast_result.runtimeType);

  await conn.close();
  // print(results);
  return results;
}

class ScheduleController extends StatelessWidget {
  final SharedPreferences prefs;
  late String name, surname;
  ScheduleController({super.key, required this.prefs}) {
    final List<String> account = prefs.getStringList('account')!;
    if (account.length > 0) {
      this.name = account[0];
      this.surname = account[1];
    } else {
      this.name = "";
      this.surname = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<PostgreSQLResult>(
        future: get_sched_by_name_surname(
            name, surname), // a previously-obtained Future<String> or null
        builder:
            (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
          if (snapshot.hasData) {
            int i = 0;
            List data = [[], [], [], [], [], [], []];
            while (i < snapshot.data!.length) {
              if (snapshot.data![i][1] == 'Понедельник') {
                data[0].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Вторник') {
                data[1].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Среда') {
                data[2].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Четверг') {
                data[3].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Пятница') {
                data[4].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Суббота') {
                data[5].add(snapshot.data![i]);
              }
              if (snapshot.data![i][1] == 'Воскресенье') {
                data[6].add(snapshot.data![i]);
              }
              i++;
            }
            return PageView(controller: PageController(), children: <Widget>[
              Center(
                child: ScheduleDay(
                  info: data[0],
                  day: 'Понедельник',
                  prefs: prefs,
                ),
              ),
              Center(
                child: ScheduleDay(info: data[1], day: 'Вторник', prefs: prefs),
              ),
              Center(
                child: ScheduleDay(
                  info: data[2],
                  day: 'Среда',
                  prefs: prefs,
                ),
              ),
              Center(
                child: ScheduleDay(
                  info: data[3],
                  day: 'Четверг',
                  prefs: prefs,
                ),
              ),
              Center(
                child: ScheduleDay(
                  info: data[4],
                  day: 'Пятница',
                  prefs: prefs,
                ),
              ),
              Center(
                child: ScheduleDay(
                  info: data[5],
                  day: 'Суббота',
                  prefs: prefs,
                ),
              ),
              Center(
                child: ScheduleDay(
                  info: data[6],
                  day: 'Воскресенье',
                  prefs: prefs,
                ),
              ),
            ]);
          } else {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }
        },
      ),
    );
  }
}
