import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:video_album/boxes/boxes.dart';
import 'package:video_album/database/save.dart';
import 'package:video_album/provider/dbprovider.dart';

class VideoPicker extends StatefulWidget {
  final String albumName;

  const VideoPicker({super.key, required this.albumName});

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> with WidgetsBindingObserver {
  var channel = MethodChannel("nativeDemo");

/*
  showToast() {
    channel.invokeMethod("showToast", {
      "stringList": _selectedFiles.map((file) => file.path).toList(),
      "booleanValue": isRandom, // Replace with your boolean value
    });
  }

  addNew() {
    channel.invokeMethod("addNew", {
      "stringList": _selectedFiles.map((file) => file.path).toList(),
    });
  }
*/

  List<String> _selectedFilePaths = []; // Store file paths

  Future<void> _pickVideos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result != null) {
        List<PlatformFile> files = result.files;

        setState(() {
          _selectedFilePaths = files.map((file) => file.path ?? "").toList();
        });
      } else {
        // User canceled the file picker
      }
    } catch (e) {
      // Handle errors
      print("Error picking videos: $e");
    }
  }

  bool isRandom = false;

  @override
  void initState() {
    super.initState();

    DbProvider().getRandomState().then((value) {
      setState(() {
        isRandom = value;
      });
    });

    loadDatabase();
  }

  var listBox;

  loadDatabase() async {
    listBox = await Hive.openBox("InsideList");
  }

  List<String> dbList = [];

  /* void saveListToDatabase() async {

    for (int i = 0; i < _selectedFilePaths.length; i++) {
      dbList.add(_selectedFilePaths[i]);
    }

    print("widget.albumName ${dbList.length}");

    await listBox.put(widget.albumName, dbList);


  }*/

  void saveListToDatabase() async {
    // Retrieve the existing list from Hive or initialize it if it doesn't exist
    final existingList = listBox?.get(widget.albumName) ?? [];

    // Add the newly selected video paths to the existing list
    existingList.addAll(_selectedFilePaths);

    print("widget.albumName ${existingList.length}");

    // Save the updated list back to Hive
    await listBox?.put(widget.albumName, existingList);

    channel.invokeMethod("addPath", {
      "albumName": widget.albumName,
      "stringListArgument": existingList,
    });

    setState(() {});
  }

  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Multiple Videos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideos,
              child: Text('Pick Videos'),
            ),
            SizedBox(height: 20),
            Text('Selected Videos:'),
            Expanded(
              child: ValueListenableBuilder<Box<Save>>(
                valueListenable: Boxes.getData().listenable(),
                builder: (context, box, _) {
                  final dbList = listBox?.get(widget.albumName) ?? [];
                  return ListView.builder(
                    itemCount: dbList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          dbList.isEmpty ? "0" : dbList[index].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  saveListToDatabase();
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}
