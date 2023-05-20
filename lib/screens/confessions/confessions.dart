import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class Confess extends StatefulWidget {
  const Confess({Key? key}) : super(key: key);

  @override
  State<Confess> createState() => _ConfessState();
}

Future<PostgreSQLResult> get_posts() async {
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
      .query('''SELECT post_id, post FROM shitposts ORDER BY post_id ASC;''');
  // PostgreSQLResult - "list" of PostgreSQLResultRow

  // var cast_result = results.asMap();
  // print(cast_result);
  // print(cast_result.runtimeType);

  await conn.close();
  // print(results);
  return results;
}

Future<void> add_post(post) async {
  final conn = PostgreSQLConnection(
    'your-ip',
    your - port,
    'your-db',
    username: 'your-username',
    password: '<your-password>',
    useSSL: true,
  );

  await conn.open();
  final results =
      await conn.query('''INSERT INTO shitposts(post) VALUES ('$post');''');
  // PostgreSQLResult - "list" of PostgreSQLResultRow

  // var cast_result = results.asMap();
  // print(cast_result);
  // print(cast_result.runtimeType);

  await conn.close();
  // print(results);
}

void useFutureAdd(post) {
  add_post(post).catchError((e) => print('It"s error:$e'));
}

class _ConfessState extends State<Confess> {
  String _post = '';
  List<String> postList = [];

  // late var postList;
  static const orange = Color.fromARGB(255, 255, 163, 26);
  static const fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Физтех ',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  fontFamily: fontFamily)),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                maxWidth: 170,
                maxHeight: 40,
              ),
              color: orange,
              child: const Text('Разговорчики',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: fontFamily)),
            ),
          )
        ]),
        //centerTitle: true,
      ),
      body: FutureBuilder<PostgreSQLResult>(
          future: get_posts(),
          builder:
              (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              print(snapshot.data);
              postList = [];
              for (var c in snapshot.data!) {
                postList.add(c[1]);
              }
              // postList.add(value)
              // snapshot.data!.length;
            }
            return ListView.separated(
              itemCount: postList.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        color: const Color.fromARGB(255, 10, 10, 10),
                        child: ListTile(
                            title: Text('Post #${postList.length - index}',
                                style: const TextStyle(
                                    fontSize: 18, color: orange)),
                            subtitle: Text(
                                postList[postList.length - index - 1],
                                style: const TextStyle(
                                    fontSize: 18,
                                    color:
                                        Color.fromARGB(255, 200, 200, 200))))));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }),
      floatingActionButton: Container(
        height: 40,
        width: 250,
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('New Post'),
                    content: TextField(
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (String value) {
                        _post = value;
                      },
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            useFutureAdd(_post);
                            setState(() {
                              postList.add(_post);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Add'))
                    ],
                  );
                });
          },
          backgroundColor: orange,
          label: const Text(
            'Add new shitpost',
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontFamily: fontFamily),
          ),
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.home),
      //         onPressed: () {
      //           Navigator.pushNamedAndRemoveUntil(
      //               context, '/schedule', (route) => false);
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
      //       IconButton(icon: const Icon(Icons.email), onPressed: () {}),
      //     ],
      //   ),
      // ),
    );
  }
}
