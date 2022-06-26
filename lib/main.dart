import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebSocketChannel channel;
  int incrementedNumber = 0;

  @override
  void initState() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/ws'),
    );

    // channel.stream.listen((event) {});
    // channel.stream.listen(print);
    channel.stream.listen((event) {
      print(event);
      print(jsonDecode(event)['value']);

      setState(() {
        incrementedNumber = jsonDecode(event)['value'];
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    channel.sink.close();
  }

  void _sendIncrementCommand() {
    // channel.sink.add('Increment');
    channel.sink.add(json.encode({
      'increment': true,
      'previous_val': incrementedNumber,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              // 'Hello, Boring Show!',
              '$incrementedNumber',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendIncrementCommand,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
