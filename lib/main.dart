import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<String>? _textStreamSubscription;
  StreamSubscription<List<SharedMediaFile>>? _mediaStreamSubscription;
  List<String> _textList = [];

  // Function to add _sharedText to a list if it is not already present
  void _addTextToListIfUnique() {
    if (!_textList.contains(_sharedText)) {
      setState(() {
        _textList.add(_sharedText);

        _saveListToStorage(_textList);
      });
    }
  }

  Future<void> _saveListToStorage(List<String> list) async {
    final file = File('${(await getApplicationDocumentsDirectory()).path}/shared_text_list.txt');
    final sink = file.openWrite();
    for (final item in list) {
      sink.writeln(item);
    }

    await sink.close();
  }

  Future<List<String>> _loadListFromStorage() async {
    final file = File('${(await getApplicationDocumentsDirectory()).path}/shared_text_list.txt');

    if (await file.exists()) {
      final contents = await file.readAsString();
      return contents.split('\n');
    }
    Future<void> _saveListToStorage(List<String> list) async {
      final file = File('${(await getApplicationDocumentsDirectory()).path}/shared_text_list.txt');
      final sink = file.openWrite();

      for (final item in list) {
        sink.writeln(item);
      }

      await sink.close();
    }
    return [];
  }
  String _sharedText = "";
  List<SharedMediaFile>? _sharedFiles;

  @override
  Widget build(BuildContext context) {
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
            if (_sharedText!.isNotEmpty)
              Text(_sharedText, style: const TextStyle(fontSize: 20)),
            if (_sharedText!.isEmpty)
              const Text("No shared Text", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 100),
            const Text("Shared files:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 5,
            ),
            if (_sharedFiles != null && _sharedFiles!.isNotEmpty)
              Text(_sharedFiles!.map((f) => f.path).join(", "), style: const TextStyle(fontSize: 20)),
            if (_sharedFiles == null || _sharedFiles!.isEmpty)
              const Text("No shared files", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadListFromStorage().then((value) {
      setState(() {
        _textList = value;
      });
    });

    //Receive text data when app is running
    _textStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String text) {
          setState(() {
            _sharedText = text;
            _addTextToListIfUnique();
          });
        });

    //Receive text data when app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text != null) {
        setState(() {
          _sharedText = text;
          _addTextToListIfUnique();
        });
      }
    });

    //Receive files when app is running
    _mediaStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) {
      setState(() {
        _sharedFiles = files;
      });
    });

    //Receive files when app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
      setState(() {
        _sharedFiles = files;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mediaStreamSubscription!.cancel();
    _textStreamSubscription!.cancel();
  }
}
