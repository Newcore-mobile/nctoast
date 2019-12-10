///
///Author: YoungChan
///Date: 2019-12-10 15:13:39
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 16:36:28
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:nctoast/nctoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future _showLoading(BuildContext context, bool success) async {
    await Future.delayed(Duration(seconds: 2));
    if (success) {
      return Future.value();
    } else {
      return Future.error('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toast'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OutlineButton(
              child: Text('显示Loading（成功）'),
              onPressed: () {
                ncShowProgressing(context, () => _showLoading(context, true))
                    .then((_) {})
                    .catchError((err) {
                  ncShowToast(context, err.toString());
                });
              },
            ),
            OutlineButton(
              child: Text('显示Loading（失败）'),
              onPressed: () {
                ncShowProgressing(context, () => _showLoading(context, false))
                    .then((_) {})
                    .catchError((err) {
                  ncShowToast(context, err.toString());
                });
              },
            ),
            OutlineButton(
              child: Text('显示Toast'),
              onPressed: () {
                ncShowToast(context, '这是一条提示');
              },
            )
          ],
        ),
      ),
    );
  }
}
