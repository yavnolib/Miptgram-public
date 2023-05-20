import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:postgres/postgres.dart';

Future<void> DelSchedByName(
    name, surname, pair_name, weekday_name, subject_name) async {
  final conn = PostgreSQLConnection(
    'your-ip',
    your - port,
    'your-db',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );
  print('$name $surname $pair_name $weekday_name $subject_name');

  await conn.open();
  final results = await conn.query(
    '''DELETE FROM schedule WHERE id in (SELECT id FROM schedule JOIN users USING(uid) JOIN weekdays USING(weekday_id) JOIN pairs USING(pair_id) JOIN subjects USING(subject_id) WHERE (name = '$name') and (surname = '$surname') and (weekday_name = '$weekday_name') and (subject_name = '$subject_name'));''',
  );

  await conn.close();
}

Future<void> AddSchedByName(
    name, surname, pair_id, weekday_name, subject_id) async {
  final conn = PostgreSQLConnection(
    'your-ip',
    your - port,
    'your-db',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );
  print('$name $surname $pair_id $weekday_name $subject_id');

  await conn.open();
  final results = await conn.query(
      '''insert into schedule (uid, subject_id, weekday_id, pair_id) values ( (select uid from users where (name='$name') and (surname='$surname')), $subject_id, (select weekday_id from weekdays where weekday_name='$weekday_name'), $pair_id);''');

  await conn.close();
}

void useFutureAddByName(name, surname, pair_id, weekday_name, subject_id) {
  AddSchedByName(name, surname, pair_id, weekday_name, subject_id)
      .catchError((e) => print('It"s error while adding:$e'));
}

void useFutureDeleteByName(
    name, surname, pair_name, weekday_name, subject_name) {
  DelSchedByName(name, surname, pair_name, weekday_name, subject_name)
      .catchError((e) => print('It"s error while delete:$e'));
}

enum PairLabel {
  one('09:00-10:25', 1),
  two('10:45-12:10', 2),
  three('12:20-13:45', 3),
  four('13:55-15:20', 4),
  five('15:30-16:55', 5),
  six('17:05-18:30', 6),
  seven('18:35-20:00', 7);

  const PairLabel(this.label, this.pair_id);
  final String label;
  final int pair_id;
}

enum SubjectLabel {
  matan('Мат.анализ', 1),
  prog('Информатика', 2),
  diff('Дифференциальные уравнения', 3),
  anmec('Аналитическая механика', 4),
  sos('Общая физика', 5);

  const SubjectLabel(this.label, this.subject_id);
  final String label;
  final int subject_id;
}

class ScheduleDay extends StatefulWidget {
  final SharedPreferences prefs;
  const ScheduleDay(
      {this.day = 'null', required this.info, super.key, required this.prefs});

  final List info;
  final String day;

  @override
  State<ScheduleDay> createState() =>
      _ScheduleDayState(day: day, info: info, prefs: prefs);
}

class _ScheduleDayState extends State<ScheduleDay> {
  final SharedPreferences prefs;
  late String name, surname, groupname;
  String _pair_name = '';

  _ScheduleDayState(
      {this.day = 'null', required this.info, required this.prefs}) {
    final List<String> account = prefs.getStringList('account')!;
    if (account.length > 0) {
      this.name = account[0];
      this.surname = account[1];
    } else {
      this.name = "";
      this.surname = "";
    }
  }

  final String day;
  // String _userTODO = '';
  final List info;

  @override
  void initState() {
    super.initState();

    // todoList.addAll([
    //   'Математический анализ',
    //   'Дифференциальные уравнения',
    //   'Теоретическая физика'
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<SubjectLabel>> subjectEntries =
        <DropdownMenuEntry<SubjectLabel>>[];
    for (final SubjectLabel subject in SubjectLabel.values) {
      subjectEntries.add(DropdownMenuEntry<SubjectLabel>(
          value: subject, label: subject.label));
    }
    SubjectLabel? selectedSubjectId = SubjectLabel.diff;

    final List<DropdownMenuEntry<PairLabel>> pairEntries =
        <DropdownMenuEntry<PairLabel>>[];
    for (final PairLabel pair in PairLabel.values) {
      pairEntries
          .add(DropdownMenuEntry<PairLabel>(value: pair, label: pair.label));
    }
    PairLabel? selectedPairId = PairLabel.one;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 54, 115, 117),
        title: Text(day),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: info.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            child: Card(
                child: ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 160,
                        maxHeight: 60,
                      ),
                      color: const Color.fromARGB(255, 42, 247, 230),
                      child: Text(info[index][2],
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black)))),
              title: Text(
                info[index][0],
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: const Text('512 ГК',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 130, 130, 130))),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.deepOrangeAccent,
                ),
                onPressed: () {
                  print(info[index]);
                  var subject_name = info[index][0];
                  var weekday_name = info[index][1];
                  var pair_name = info[index][2];
                  useFutureDeleteByName(
                      name, surname, pair_name, weekday_name, subject_name);
                  setState(() {
                    info.removeAt(index);
                  });
                },
              ),
            )),
            onDismissed: (direction) {
              // if (direction == DismissDirection.)
              print(info[index]);
              var subject_name = info[index][0];
              var weekday_name = info[index][1];
              var pair_name = info[index][2];
              useFutureDeleteByName(
                  name, surname, pair_name, weekday_name, subject_name);

              setState(() {
                info.removeAt(index);
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 42, 247, 230),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Добавить занятие'),
                  content: Row(
                    children: <Widget>[
                      DropdownMenu<PairLabel>(
                        initialSelection: PairLabel.one,
                        controller: TextEditingController(),
                        label: const Text('Время'),
                        dropdownMenuEntries: pairEntries,
                        onSelected: (PairLabel? pair) {
                          setState(() {
                            selectedPairId = pair;
                          });
                        },
                      ),
                      DropdownMenu<SubjectLabel>(
                        initialSelection: SubjectLabel.diff,
                        controller: TextEditingController(),
                        label: const Text('Занятие'),
                        dropdownMenuEntries: subjectEntries,
                        onSelected: (SubjectLabel? subject) {
                          setState(() {
                            selectedSubjectId = subject;
                          });
                        },
                      )
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          useFutureAddByName(
                              name,
                              surname,
                              selectedPairId?.pair_id,
                              day,
                              selectedSubjectId?.subject_id);
                          setState(() {
                            info.add([
                              selectedSubjectId?.label,
                              day,
                              selectedPairId?.label
                            ]);
                          });
                          print(info[info.length - 1]);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Добавить'))
                  ],
                );
              });
        },
        tooltip: 'Добавить предмет',
        child: const Icon(Icons.add),
      ),
    );
    // bottomNavigationBar: BottomAppBar(
    //   child: Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       IconButton(
    //         icon: const Icon(Icons.home),
    //         onPressed: () {
    //           Navigator.pushNamedAndRemoveUntil(
    //               context, '/entry', (route) => false);
    //         },
    //       ),
    //       PopupMenuButton(
    //         icon: const Icon(Icons.share),
    //         itemBuilder: (context) => [
    //           const PopupMenuItem(
    //             value: 1,
    //             child: Text("Facebook"),
    //           ),
    //           const PopupMenuItem(
    //             value: 2,
    //             child: Text("Instagram"),
    //           ),
    //         ],
    //       ),
    //       IconButton(
    //         icon: const Icon(Icons.email),
    //         onPressed: () {
    //           Navigator.pushNamedAndRemoveUntil(
    //               context, '/confessions', (route) => false);
    //         },
    //       ),
    //     ],
    //   ),
    // ),
  }
}
