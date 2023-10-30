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
        body: Stack(
          children: [
            // Background Image
            Stack(
              fit: StackFit.expand, // Make the stack take up the entire screen
              children: [
                Image.asset(
                  'assets/images/bg.png', // Replace with your image file's path
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ],
            ),

            // Buttons and content

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0, left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "assets/images/appname (1).png",
                              height: 85,
                              // width: 135,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.only(left: 13.0, top: 28),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/App Name.png",
                              height: 100,
                              width: 195,
                            ),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xff472619),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AssetVideos()));
                                      },
                                      child: Image.asset(
                                          "assets/images/info.png",
                                          height: 38,
                                          width: 33,
                                          fit: BoxFit.contain),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Image.asset("assets/images/ads.png",
                                        height: 38,
                                        width: 33,
                                        fit: BoxFit.contain),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      childAspectRatio: 0.70,
                      shrinkWrap: true,
                      primary: false,
                      padding:
                          const EdgeInsets.only(left: 18, top: 15, right: 18),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 0,
                      crossAxisCount: 3,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AssetVideos()));
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/btn1.png"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Live Wallpaper",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage()));
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/btn2.png"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Set album",
                                    style: TextStyle(color: Colors.white))
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingScreen()));
                            },
                            child: Column(
                              children: [
                                Image.asset("assets/images/btn3.png"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Settings",
                                    style: TextStyle(color: Colors.white))
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /*Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssetVideos()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()));
                  },
                  child: Text("Settings"),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
