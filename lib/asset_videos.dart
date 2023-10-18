import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
    VideoItem(name: 'Video 1', assetPath: 'assets/videos/vid_1.mp4'),
    VideoItem(name: 'Video 2', assetPath: 'assets/videos/vid_2.mp4'),
    VideoItem(name: 'Video 3', assetPath: 'assets/videos/vid_3.mp4'),
    VideoItem(name: 'Video 4', assetPath: 'assets/videos/vid_4.mp4'),
    VideoItem(name: 'Video 5', assetPath: 'assets/videos/vid_5.mp4'),
    VideoItem(name: 'Video 6', assetPath: 'assets/videos/vid_6.mp4'),
    VideoItem(name: 'Video 7', assetPath: 'assets/videos/vid_7.mp4'),
    VideoItem(name: 'Video 8', assetPath: 'assets/videos/vid_8.mp4'),
    VideoItem(name: 'Video 9', assetPath: 'assets/videos/vid_9.mp4'),
    // Add the remaining videos here
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
        maxHeight: 200,
        maxWidth: 200
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
          title: Text('Video Thumbnails'),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: videoItems.length,
          itemBuilder: (context, index) {
            final videoItem = videoItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssetVideoPlayer(videoAssetPath: videoItems[index].assetPath,)));
              },
              child: Card(
                child: Column(
                  children: [
                    if (_thumbnailFiles[index] != null)
                      Image.file(File(_thumbnailFiles[index]!)),
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
    );
  }
}
