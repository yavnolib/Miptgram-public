import 'package:postgres/postgres.dart';

void main() {
  useFuture1();
}

void useFuture1() {
  get_sched_by_uid(uid: 4)
      .then((value) => print(value))
      .catchError((e) => print(e));
}

Future<PostgreSQLResult> get_sched_by_uid({int uid = 4}) async {
  final conn = PostgreSQLConnection(
    'your-ip',
    your - port,
    'your-db',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );

  await conn.open();
  final results = await conn
      .query('''SELECT subject_name, weekday_name, pair_name FROM schedule 
      JOIN weekdays USING(weekday_id) JOIN pairs USING(pair_id) JOIN subjects USING(subject_id) WHERE uid = $uid;''');

  await conn.close();
  return results;
}
