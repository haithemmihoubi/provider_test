import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home page'),
      ),
    );
  }
}

// define a class
class BreadCrumb {
  late final String uuid;
  late bool isActive;

  late final String name;

  BreadCrumb({required this.isActive, required this.name})
      : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  String get title => name + (isActive ? ' > ' : '');
}

class BreadCrumbProvider with ChangeNotifier {
  final List<BreadCrumb> _items = [];
  UnmodifiableListView<BreadCrumb> get item => UnmodifiableListView(_items);
}
