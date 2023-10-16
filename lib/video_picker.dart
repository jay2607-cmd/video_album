import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:video_album/boxes/boxes.dart';
import 'package:video_album/database/save.dart';
import 'package:video_album/provider/dbprovider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPicker extends StatefulWidget {
  final String albumName;

  const VideoPicker({super.key, required this.albumName});

  @override
  State<VideoPicker> createState() => _VideoPickerState();

}

class _VideoPickerState extends State<VideoPicker> with WidgetsBindingObserver {
  var channel = const MethodChannel("nativeDemo");

  List<String> _selectedFilePaths = []; // Store file paths

  Future<Uint8List?> _generateVideoThumbnail(String videoPath) async {
    final uint8List = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 25,
    );
    return uint8List;
  }

  Future<void> _pickVideos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result != null) {
        List<PlatformFile> files = result.files;

        setState(() {
          List<String> newItemData = [];
          _selectedFilePaths = listBox?.get(widget.albumName) ?? [];

          for (var file in files) {
            String? filePath = file.path;
            if (filePath != null) {
              if (!_selectedFilePaths.contains(filePath)) {
                newItemData.add(filePath);
              }
              // listBox?.put(widget.albumName, newItemData);
            }
          }
          _selectedFilePaths.addAll(newItemData);
          print("_selectedFileSize ${_selectedFilePaths.length}");
          listBox?.put(widget.albumName, _selectedFilePaths);
          saveListToDatabase(newItemData);
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

  void saveListToDatabase(List<String> newItemData) async {
    channel.invokeMethod("addPath", {
      "albumName": widget.albumName,
      "stringListArgument": newItemData,

    });

    setState(() {});
  }

  void _deleteVideo(int index, String videoPath) {
    // Remove the item from the database
    List<String> updatedList = listBox?.get(widget.albumName) ?? [];

    // Remove the item from the UI by updating the state
    updatedList.removeAt(index);

    updatedList.remove(videoPath);
    listBox?.put(widget.albumName, updatedList);


    // remove path from native side as well
    channel.invokeMethod("deletePath", {
      "albumName": widget.albumName,
      "videoPath": videoPath,
    });

    setState(() {});

    // Additionally, you can delete the video file from storage if needed
    // File(videoPath).deleteSync();



  }

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
                      String videoPath = dbList[index];
                      return FutureBuilder(
                        future: _generateVideoThumbnail(videoPath),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  dbList.isEmpty
                                      ? "0"
                                      : dbList[index]
                                          .toString()
                                          .split("/")
                                          .last,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                leading: Container(
                                  width: 100, // Set the desired width
                                  height: 100, // Set the desired height
                                  child: Center(
                                    child: Image.memory(
                                        snapshot.data ?? Uint8List(0)),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    print("indexi $index");
                                    _deleteVideo(index, videoPath);
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  dbList.isEmpty
                                      ? "0"
                                      : dbList[index]
                                          .toString()
                                          .split("/")
                                          .last,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                leading: Container(
                                  width: 100, // Set the desired width
                                  height: 100, // Set the desired height
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteVideo(index, videoPath);
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
