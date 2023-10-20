import 'package:flutter/material.dart';
import 'package:video_album/album_page.dart';
import 'package:video_album/settings.dart';

import 'asset_videos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Video Album"),),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AssetVideos()));
                },
                child: Text("Live Wallpaper")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AlbumPage()));
                },
                child: Text("Set Album")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                child: Text("Settings"))
          ],
        ),
      ),
    );
  }
}
