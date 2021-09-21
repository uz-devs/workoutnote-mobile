import 'package:flutter/material.dart';


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {


  List<String> list  = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'
  ];
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(



      onReorder: _onReorder,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: List.generate(
        list.length,
            (index) {
          return Card(
            key: Key('$index'),
            child:Text('${list[index]}'),

          );
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
          () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final String item = list.removeAt(oldIndex);
        list.insert(newIndex, item);
      },
    );
  }
}
