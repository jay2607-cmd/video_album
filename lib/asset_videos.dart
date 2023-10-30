import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_album/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'asset_video_player.dart';
import 'model/video_item.dart';

class AssetVideos extends StatefulWidget {
  const AssetVideos({super.key});

  @override
  State<AssetVideos> createState() => _AssetVideosState();
}

class _AssetVideosState extends State<AssetVideos> {

  List<VideoItem> videoItems = [
    VideoItem(name: 'Video 1', assetPath: 'assets/videos/Video_1.mp4'),
    VideoItem(name: 'Video 2', assetPath: 'assets/videos/Video_2.mp4'),
    VideoItem(name: 'Video 3', assetPath: 'assets/videos/Video_3.mp4'),
    VideoItem(name: 'Video 4', assetPath: 'assets/videos/Video_4.mp4'),
    VideoItem(name: 'Video 5', assetPath: 'assets/videos/Video_5.mp4'),
    VideoItem(name: 'Video 6', assetPath: 'assets/videos/Video_6.mp4'),
    VideoItem(name: 'Video 7', assetPath: 'assets/videos/Video_7.mp4'),
    VideoItem(name: 'Video 8', assetPath: 'assets/videos/Video_8.mp4'),
    VideoItem(name: 'Video 9', assetPath: 'assets/videos/Video_9.mp4'),
  ];

  List<String?> _thumbnailFiles = List.filled(9, null); // Initialize with nulls

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < videoItems.length; i++) {
      generateThumbnail(i, videoItems[i].assetPath);
    }
  }

  Future<File> copyAssetFile(String assetFileName) async {
    Directory tempDir = await getTemporaryDirectory();
    final byteData = await rootBundle.load(assetFileName);

    File videoThumbnailFile = File("${tempDir.path}/$assetFileName")
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return videoThumbnailFile;
  }

  generateThumbnail(int index, String path) async {
    File videoTempFile1 = await copyAssetFile(path);

    _thumbnailFiles[index] = await VideoThumbnail.thumbnailFile(
      video: videoTempFile1.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 225,
    );
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
              "Live Wallpaper",
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: 9,
            itemBuilder: (context, index) {
              final videoItem = videoItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssetVideoPlayer(
                                videoAssetPath: videoItems[index].assetPath,
                              )));
                },
                child: Card(
                  child: Column(
                    children: [
                      if (_thumbnailFiles[index] != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.file(File(_thumbnailFiles[index]!))),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(videoItem.name),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
