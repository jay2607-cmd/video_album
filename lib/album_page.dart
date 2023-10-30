import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_album/provider/db_provider.dart';
import 'package:video_album/video_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'boxes/boxes.dart';
import 'database/save.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final TextEditingController categoryController = TextEditingController();

  List<String> categoryList = [];
  var channel = MethodChannel("nativeDemo");

  var data;

  var listBox;

  List<String> dbList = [];

  List<String> _selectedFilePaths = []; // Store file paths

  void saveListToDatabase() async {
    // Retrieve the existing list from Hive or initialize it if it doesn't exist
    final existingList = listBox?.get(album) ?? [];

    // Add the newly selected video paths to the existing list
    existingList.addAll(_selectedFilePaths);

    print("widget.albumName ${existingList.length}");

    // Save the updated list back to Hive
    await listBox?.put(album, existingList);

    setState(() {});
  }

  bool isRandom = false;
  bool isUnMuted = false;
  bool isDoubleTappedOn = false;

  @override
  void initState() {
    // addCategory();
    super.initState();

    DbProvider().getRandomState().then((value) {
      setState(() {
        isRandom = value;
      });
    });

    DbProvider().getUnMuteState().then((value) {
      setState(() {
        isUnMuted = value;
      });
    });

    DbProvider().getDoubleTap().then((value) {
      setState(() {
        isDoubleTappedOn = value;
      });
    });

    loadListData();
  }

  loadListData() async {
    listBox = await Hive.openBox("InsideList");
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void addCategory() {
    var data = Save(name: categoryController.text, path: []);
    var box = Boxes.getData();

    bool categoryExists = box.values
        .any((item) => item.name.toLowerCase() == data.name.toLowerCase());

    if (categoryExists) {
      showInSnackBar("Category already exists!");
      return; // Don't add the category if it already exists
    } else if (categoryController.text.trim().isEmpty) {
      showInSnackBar("Category Cannot be Empty");
    } else {
      box.add(data);
      categoryList.add(data.name);
      print("categoryList.last ${categoryList.last}");
    }

    setState(() {});
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: 'Type something...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Access the text from the controller
                final enteredText = categoryController.text;
                print('Entered Text: $enteredText');
                addCategory();
                categoryController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadVideo(String videoAssetPath) async {
    try {
      // Get the external storage directory
      final directory = await getExternalStorageDirectory();

      // Generate a unique file name for the downloaded video
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Create the target file path in the external storage directory
      final targetVideoPath = '${directory!.path}/$fileName';

      // Load the video data from the asset
      final data = await rootBundle.load(videoAssetPath);
      final videoBytes = data.buffer.asUint8List();

      // Write the video data to the target file
      await File(targetVideoPath).writeAsBytes(videoBytes);

      print('Video downloaded to: $targetVideoPath');
      Fluttertoast.showToast(
          msg: "Video downloaded to: $targetVideoPath",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    } catch (e) {
      print('Error while downloading: $e');
    }
  }

  albumName(String album) {
    channel.invokeMethod("albumName", {
      "category": album,
      "isRandom": isRandom,
      "isUnMuted": isUnMuted,
      "isDoubleTappedOn": isDoubleTappedOn
    });
  }

  void shareMultipleVideos() async {
    List<String> videoFilePaths = listBox?.get(album) ?? [];

    // Check if the files exist
    final existingVideoFiles = await Future.wait(
      videoFilePaths.map((videoFilePath) => File(videoFilePath).exists()),
    );

    if (existingVideoFiles.every((exists) => exists)) {
      await Share.shareFiles(videoFilePaths, text: album);
    } else {
      // Handle the case where some of the files don't exist
      for (var i = 0; i < videoFilePaths.length; i++) {
        print(videoFilePaths[i]);
        if (!existingVideoFiles[i]) {
          print("Video file not found at ${videoFilePaths[i]}");
        }
      }
    }
  }

  Future<Uint8List?> generateVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
        maxHeight: 325,
        maxWidth: 250);
    return thumbnail;
  }

  var album;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                iconSize: 50,
                onPressed: _openDialog,
                icon: Image.asset(
                  "assets/images/add.png",
                ))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/images/back.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {},
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Albums",
            ),
          ),
        ),
        body: ValueListenableBuilder<Box<Save>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            data = box.values.toList().cast<Save>();
            // dataLegnth.length =  data.length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.55),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  album = data[index].name;
                  final videoPaths = listBox?.get(album) ?? [];
                  print("data[index].path ${data[index].path}");
                  final firstVideoThumbnailFuture = videoPaths.isNotEmpty
                      ? generateVideoThumbnail(videoPaths
                          .first) // Assuming the first video path in the list
                      : Future.value(
                          null); // Return a completed Future with null when no videos are available

                  return GestureDetector(
                    onTap: () {
                      // TODO: On tap of category
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPicker(
                            albumName: data[index].name,
                          ),
                        ),
                      );
                    },
                    child: Card(
                        child: Container(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /*Text(
                                          "${data[index].name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            albumName(data[index].name);
                                          },
                                          child: Text("Set"),
                                        ),*/
                                  FutureBuilder<Uint8List?>(
                                    future: firstVideoThumbnailFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data != null) {
                                        return Stack(
                                          children: [
                                            ClipRect(
                                              clipper: ThumbnailClipper(0.9),
                                              child: Opacity(
                                                opacity: 0.3,
                                                child: Image.memory(
                                                    snapshot.data!,
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                            Container(
                                              color: Colors
                                                  .black, // You can change the overlay color
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: PopupMenuButton<String>(
                                                icon: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      bottom: 12.0,
                                                      left: 14),
                                                  child: Icon(
                                                      Icons.more_horiz_rounded),
                                                ),
                                                onSelected: (result) {
                                                  if (result ==
                                                      "deleteCategory") {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                      context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Warning!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                          content: const Text(
                                                              'Do you really want to delete this Category!'),
                                                          actions: [
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text('OK'),
                                                              onPressed: () {
                                                                if (categoryList
                                                                    .isNotEmpty) {
                                                                  delete(data[
                                                                  index]
                                                                      .name);
                                                                  print(
                                                                      "Before Deletion: categoryList: $categoryList");
                                                                  categoryList.remove(
                                                                      categoryList
                                                                          .last);
                                                                  print(
                                                                      "After Deletion: categoryList: $categoryList");
                                                                }
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                    setState(() {});
                                                  } else if (result ==
                                                      "shareAlbum") {
                                                    shareMultipleVideos();
                                                  } else if (result ==
                                                      "Download") {
                                                    downloadVideo(
                                                        'assets/videos/vid_3.mp4');
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return <PopupMenuEntry<
                                                      String>>[
                                                    PopupMenuItem<String>(
                                                      value: 'deleteCategory',
                                                      child: Text('Delete'),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: 'shareAlbum',
                                                      child:
                                                      Text('Share Album'),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: 'Download',
                                                      child: Text('Download'),
                                                    ),
                                                  ];
                                                },
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 40,
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xffFF6332),
                                                        ),
                                                        onPressed: () {
                                                          albumName(
                                                              data[index].name);
                                                        },
                                                        child: Text("Set"),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "${data[index].name}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      } else {
                                        return Image.asset(
                                          'assets/images/placeholder.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton<String>(
                                    icon: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, left: 14),
                                      child: Icon(Icons.more_horiz_rounded),
                                    ),
                                    onSelected: (result) {
                                      if (result == "deleteCategory") {
                                        showDialog(
                                          context: context,
                                          // Make sure this is the correct context
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Warning!',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              content: const Text(
                                                  'Do you really want to delete this Category!'),
                                              actions: [
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // This closes the dialog
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    // Perform the deletion here
                                                    delete(data[index]);
                                                    categoryList.remove(
                                                        categoryList.last);

                                                    // Close the dialog
                                                    Navigator.pop(context);
                                                    print(
                                                        "categoryList.last ${categoryList.length}");
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        setState(() {});
                                      } else if (result == "shareAlbum") {
                                        shareMultipleVideos();
                                      } else if (result == "Download") {
                                        downloadVideo('assets/videos/vid_3.mp4');
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'deleteCategory',
                                          child: Text('Delete'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'shareAlbum',
                                          child: Text('Share Album'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Download',
                                          child: Text('Download'),
                                        ),
                                      ];
                                    },
                                  ),
                                ),*/
                        ],
                      ),
                    )),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void delete(Save save) async {
    print(save);
    await save.delete();

    setState(() {});

    // Hive.box("SaveModel").clear();
  }
}

class ThumbnailClipper extends CustomClipper<Rect> {
  final double aspectRatio;

  ThumbnailClipper(this.aspectRatio);

  @override
  Rect getClip(Size size) {
    // Calculate the clip rectangle based on the aspectRatio
    double width;
    double height;
    if (size.aspectRatio > aspectRatio) {
      width = size.height * aspectRatio;
      height = size.height;
    } else {
      width = size.width;
      height = size.width / aspectRatio;
    }
    final offsetX = (size.width - width) / 2;
    final offsetY = (size.height - height) / 2;
    return Rect.fromLTWH(offsetX, offsetY, width, height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
