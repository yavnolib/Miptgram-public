import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BottomAppBar Example"),
        ),
        body: const Center(
            child: Text(
          'Flutter BottomAppBar Example',
        )),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              PopupMenuButton(
                icon: const Icon(Icons.share),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Facebook"),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Instagram"),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.email),
                onPressed: () {
                  Navigator.pushNamed(context, '/confessions');
                },
              ),
            ],
          ),
        ));
  }
}
