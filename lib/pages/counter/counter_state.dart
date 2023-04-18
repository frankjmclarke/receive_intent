import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'counter_notifier.dart';

class CounterState {
  CounterState({
    this.value = 0,
    List<String>? textList,
  }) : textList = textList ?? [] {
    initializeTextStreamSubscription();
  }
  //final CounterNotifier counterNotifier = ref.watch(counterProvider.notifier);
  final int value;
  bool loaded = false;
  StreamSubscription<String>? textStreamSubscription;
  late String _sharedText;
  List<String> textList;

  void initializeTextStreamSubscription() { //this gets called on sharing from Chrome
    textStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      loadList(value);
    });
  }

  /// This is just a simple utility method, for more complex classes you might want to try out 'freezed'
  CounterState copyWith({int? count}) {
    return CounterState(
      value: count ?? value,//returns the expression on its left when the it's not null
    );
  }
  CounterState read(List<String>? list) {
    initializeTextStreamSubscription();
    return CounterState(
      textList: list ?? textList,
    );

  }

  void addTextToListIfUnique(String sharedText) {
    if (!textList.contains(sharedText)) {
        textList.add(sharedText);
        saveListToStorage(textList);
    }
  }

  Future<void> saveListToStorage(List<String> list) async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/shared_text_list.txt');
    final sink = file.openWrite();
    for (final item in list) {
      sink.writeln(item);
    }
    await sink.close();
  }

  void loadList(String value) async {
    if (loaded) {
      addTextToListIfUnique(value);
    }else {
      loaded = true;
      final file = File(
          '${(await getApplicationDocumentsDirectory())
              .path}/shared_text_list.txt');
      if (await file.exists()) {
        final contents = await file.readAsString();
        textList = contents.split('\n');
        addTextToListIfUnique(value);
      }
    }
  }

  Future<List<String>> loadListFromStorage() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/shared_text_list.txt');
    if (await file.exists()) {
      final contents = await file.readAsString();
      return contents.split('\n');
    }
    return [];
  }



}
