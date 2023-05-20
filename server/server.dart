import 'package:postgres/postgres.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

// !!!!!!!!!!! 105 signinform
void main() {
  useFuture1('<mail>', '12345678');
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input + 'kisy lubish')).toString();
}

void useFuture1(email, password) {
  get_sched_by_uid(email, password).catchError((e) => print('It"s error:$e'));
}

Future<void> get_sched_by_uid(String email, String password) async {
  final conn = PostgreSQLConnection(
    '<your-ip>',
    your - port,
    '<your-db>',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );

  await conn.open();
  print(email);
  try {
    dynamic results;
    var name, surname, groupname;
    try {
      results = await conn.query('''SELECT name, surname, group_name 
          FROM users JOIN groups USING(group_id) 
          WHERE email=@email;''', substitutionValues: {'email': email});
      if (results.length > 0) {
        name = results[0][0];
        surname = results[0][1];
        groupname = results[0][2];
      } else {
        name = "";
        surname = "";
        groupname = "";
      }
    } on Exception catch (e, s) {
      results = [];
      name = "";
      surname = "";
      groupname = "";
    }
    print(<String>[name, surname, groupname]);
  } finally {
    await conn.close();
  }
}
