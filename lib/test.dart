import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGo Anime',
      // debugShowCheckedModeBanner: false,

      theme: ThemeData(
        backgroundColor: const Color(0xff95C8D8),
        primaryColor: const Color(
          0xff003366,
        ),
      ),
      home: NewWidget(),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              color: Colors.red,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // width: double.,
            )
          ],
        ),
      ),
    );
  }
}
