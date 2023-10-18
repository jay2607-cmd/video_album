import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
// import 'package:video_wallpaper/change_wallpaper.dart';

class AssetVideoPlayer extends StatefulWidget {
  final String videoAssetPath;

  const AssetVideoPlayer({super.key, required this.videoAssetPath});

  @override
  _AssetVideoPlayerState createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<AssetVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  String _platformVersion = 'Unknown';
  String _liveWallpaper = 'Unknown';

  // Update the asset path to match your video asset.
  late String assetVideoPath;

  late bool goToHome;
  String tempVideoFileName = 'temp_video.mp4'; // Unique temporary file name

  @override
  void initState() {
    super.initState();
    goToHome = false;
    initPlatformState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoAssetPath);
    _chewieController = ChewieController(
      showControls: true,

      allowFullScreen: true,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping:
      true, // You can set looping to false if you don't want the video to loop.
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await AsyncWallpaper.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  var channel = MethodChannel("nativeDemo");


  showToast() {
    channel.invokeMethod("showToast");
  }

  Future<void> setLiveWallpaper() async {
    assetVideoPath = widget.videoAssetPath;

    setState(() {
      _liveWallpaper = 'Loading';
    });
    String result;

    try {
      // Generate a unique temporary file name for each video.
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final tempVideoFile = File('${appDocumentsDirectory.path}/$tempVideoFileName');

      if (!tempVideoFile.existsSync() || assetVideoPath != tempVideoFileName) {
        // Clear cache and copy the new video asset to the temporary file.
        final ByteData data = await rootBundle.load(assetVideoPath);
        final List<int> bytes = data.buffer.asUint8List();
        await tempVideoFile.writeAsBytes(bytes);
      }

      // Check if the file exists before trying to delete it.
      if (tempVideoFile.existsSync()) {

        // activate the native side
        print("called from flutter");
        showToast();

        // Use the path of the temporary video file to set the wallpaper.
        result = await AsyncWallpaper.setLiveWallpaper(
          filePath: tempVideoFile.path,

          goToHome: goToHome,
          toastDetails: ToastDetails.success(),
          errorToastDetails: ToastDetails.error(),
        )
            ? 'Wallpaper set'
            : 'Failed to set wallpaper.';
      } else {
        result = 'File not found.';
        Fluttertoast.showToast(msg: "File Not Found",toastLength: Toast.LENGTH_SHORT);


      }
    } on PlatformException {
      result = 'Failed to set wallpaper.';
      Fluttertoast.showToast(msg: "This Device Doesn't Support Live Wallpaper!",toastLength: Toast.LENGTH_SHORT);

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _liveWallpaper = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(
              onPressed: setLiveWallpaper,
              icon: Icon(Icons.change_circle))
        ],
      ),
      body: Center(
        child: Chewie(controller: _chewieController),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
