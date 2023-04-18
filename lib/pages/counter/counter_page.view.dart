import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'counter_notifier.dart';
import 'counter_state.dart';
/*
class MyWidgetProps {
  MyWidgetProps({required this.name});

  final String name;
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends HookConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  //final MyWidgetProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CounterState counterState = ref.watch(counterProvider);
    final CounterNotifier counterNotifier = ref.watch(counterProvider.notifier);
    //CounterState counterState = CounterState(textList: ['one', 'two', 'three']);

    return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: const Text("Receive intent example"),
       ),
       body: Container(
         margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Text(
               "Shared Text:",
               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
             ),
             const SizedBox(
               width: 5,
             ),
             if (counterState.textList.isNotEmpty)
               Text(counterState.textList[0], style: const TextStyle(fontSize: 20))
             else
               const Text("No shared Text", style: TextStyle(fontSize: 20)),
             const SizedBox(height: 20),if (counterState.textList.isNotEmpty)
               const Text(
                 "Saved files:",
                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
               )
             else
               const Text(
                 "No saved files",
                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
               ),
             SizedBox(
               height: 250,
               child: LayoutBuilder(
                 builder: (BuildContext context, BoxConstraints constraints) {
                   return SizedBox(
                     child: ListView.builder(
                       itemCount: counterState.textList.length,
                       itemBuilder: (context, index) {
                         final item = counterState.textList[index];
                         return Dismissible(
                           key: Key(item),
                           onDismissed: (direction) {
                             //setState(() {
                             counterState.textList.removeAt(index);
                             //});
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                 content: Text("Item deleted"),
                                 duration: Duration(seconds: 1),
                               ),
                             );
                           },
                           child: Card(
                             elevation: 3,
                             margin: const EdgeInsets.symmetric(vertical: 5),
                             child: ListTile(
                               title: EditableText(
                                 controller: TextEditingController(text: item),
                                 onChanged: (value) {
                                   //setState(() {
                                   counterState.textList[index] = value.toString();
                                   //});
                                 },
                                 backgroundCursorColor: Colors.blue,
                                 cursorColor: Colors.white,
                                 focusNode: FocusNode(),
                                 style: const TextStyle(fontSize: 20),
                               ),
                               subtitle: TextFormField(
                                 initialValue: item.length.toString(),
                                 keyboardType: TextInputType.number,
                                 decoration: const InputDecoration(
                                   hintText: 'Enter a number',
                                 ),
                                 onChanged: (value) {
                                   //setState(() {
                                     // _textList[index] = value;
                                   //});
                                 },
                               ),
                             ),
                           ),
                         );
                       },
                     ),
                   );
                 },
               ),
             )
           ],
         ),
       ),
     );
  }
}
