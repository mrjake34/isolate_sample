import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolate_sample/isolates.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white54),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Isolate Sample Project'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IsolateListen(),
            const SpawnIsolate(),
            const HelloIsolate(),
            const WorldIsolate()
          ],
        ),
      ),
    );
  }
}

class WorldIsolate extends StatelessWidget {
  const WorldIsolate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => IsolateController.sendNewMessage('World'),
        child: const Text('World'));
  }
}

class HelloIsolate extends StatelessWidget {
  const HelloIsolate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => IsolateController.sendNewMessage('Hello'),
        child: const Text('Hello'));
  }
}

class SpawnIsolate extends StatelessWidget {
  const SpawnIsolate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => IsolateController.spawn(), child: const Text('Spawn'));
  }
}

class IsolateListen extends StatefulWidget {
  IsolateListen({
    super.key,
  }) : receivePort = IsolateController.getPort;
  final ReceivePort receivePort;

  @override
  State<IsolateListen> createState() => _IsolateListenState();
}

class _IsolateListenState extends State<IsolateListen> {
  String? _message;
  Future<void> listen(ReceivePort port) async {
    port.listen((message) {
      if (_message == message) return;
      _message = message;
      setState(() {});
    });
  }

  @override
  void initState() {
    listen(widget.receivePort);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _message ?? 'No Message',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}
