import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        routes: {
          '/new': (context) => const NewBreadCrumbWidget(),
        },
      ),
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
      body: Column(
        children: [
          Consumer<BreadCrumbProvider>(
            builder: (context, value, _) {
              return BreadCrumsWidget(breadCrumbs: value.items);
            },
          ),
          TextButton(
            onPressed: () => {Navigator.of(context).pushNamed('/new')},
            child: const Text("add new"),
          ),
          TextButton(
            onPressed: () =>
            {
              context.read<BreadCrumbProvider>().reset()
            },
            child: const Text("reset"),
          ),
        ],
      ),
    );
  }
}

//? define a class  BreadCrumb
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

// breadcum with change notifier provider
class BreadCrumbProvider with ChangeNotifier {
  final List<BreadCrumb> _items = [];

  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  // add a new item
  void add(BreadCrumb item) {
    for (final item in _items) {
      item.activate();
    }
    _items.add(item);
    notifyListeners();
  }

  // rest  items
  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumsWidget({Key? key, required this.breadCrumbs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs
          .map((breadCrumb) =>
          Text(
            breadCrumb.title,
            style: TextStyle(
              color: breadCrumb.isActive ? Colors.cyan : Colors.black,
              fontSize: 20,
            ),
          ))
          .toList(),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({Key? key}) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}



class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  //? declaring  initilizing a text editing controller to get the text from the text field
  late final TextEditingController _controller;

  initState() {
    _controller = TextEditingController();
    super.initState();
  }

  //! get rid of the controller when the widget is disposed rememeber to dispose the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('add a new breadcrumd'),),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'enter a name',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          TextButton(
            onPressed: () {
              final text = _controller.text;
              if (text.isNotEmpty) {
                context.read<BreadCrumbProvider>().add(BreadCrumb(isActive: false, name: text));
                Navigator.of(context).pop();
              }


            },
            child: const Text('add'),
          ),
        ],
      ),


    );
  }
}
