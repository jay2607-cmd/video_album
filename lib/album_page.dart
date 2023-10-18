import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:video_album/provider/db_provider.dart';
import 'package:video_album/video_picker.dart';

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

  /* void saveListToDatabase() async {

    for (int i = 0; i < _selectedFilePaths.length; i++) {
      dbList.add(_selectedFilePaths[i]);
    }

    print("widget.albumName ${dbList.length}");

    await listBox.put(widget.albumName, dbList);


  }*/

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
    // Dispose the TextEditingController to prevent memory leaks
    // Dispose the TextEditingController to prevent memory leaks
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
                // TODO : add backend code as well

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

  albumName(String album) {
    channel.invokeMethod("albumName", {
      "category": album,
      "isRandom": isRandom,
      "isUnMuted": isUnMuted,
      "isDoubleTappedOn": isDoubleTappedOn
    });
  }

  var album;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ValueListenableBuilder<Box<Save>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _) {
              data = box.values.toList().cast<Save>();
              // dataLegnth.length =  data.length;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 6,
                ),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  album = data[index].name;
                  return GestureDetector(
                    onTap: () {
                      // TODO: On tap of category
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoPicker(
                                    albumName: data[index].name,
                                  )));
                    },
                    child: Card(
                      color: Color(0xffF6F7F8),
                      child: Container(
                        color: Color(0xffF0F1F5),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${data[index].name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          albumName(data[index].name);
                                        },
                                        child: Text("Set"))

                                    /* Text(
                                      listBox == null
                                          ? ""
                                          : listBox.get(data[index].name) == null ||
                                          listBox.get(data[index].name).isEmpty // Check if the list is empty
                                          ? "0"
                                          : listBox.get(data[index].name).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                icon: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12.0, left: 14),
                                  child: Icon(Icons.more_horiz_rounded),
                                ),
                                onSelected: (deleteCategory) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Warning!',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        content: const Text(
                                            'Do you really want to delete this Category!'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              delete(data[index]);
                                              categoryList
                                                  .remove(categoryList.last);

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
                                },
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'deleteCategory',
                                      child: Text('Delete'),
                                    ),
                                  ];
                                },
                              ),
                            ),
                            // SizedBox(
                            //   height: 4,
                            // ),
                            // Text(
                            //     "Date  :  ${data[reversedIndex].date.toString()}",
                            //     style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openDialog,
            child: Icon(Icons.add),
          )),
    );
  }

  void delete(Save save) async {
    print(save);
    await save.delete();

    // Hive.box("SaveModel").clear();
  }
}
