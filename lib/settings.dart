import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_album/provider/db_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isRandom = false;
  bool isUnMuted = false;
  bool isDoubleTappedOn = false;

  @override
  void initState() {
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
  }

  var channel = MethodChannel("nativeDemo");

  setRandom() {
    channel.invokeMethod("setRandom", {
      "isRandomSwitch": isRandom,
    });
  }

  setMusic() {
    channel.invokeMethod("setMusic", {
      "isUnMuted": isUnMuted,
    });
  }

  Future<void> requestPermission() async {
    const permission = Permission.systemAlertWindow;

    if (await permission.isDenied) {
      await permission.request();
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
              "Settings",
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff372F2E),

                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Allow Random Wallpaper",
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                          activeColor: Color(0xffFC5B33),
                          activeTrackColor: Color(0xff857674),
                          inactiveThumbColor: Color(0xffA7B2C7),
                          inactiveTrackColor: Color(0xffDCE0ED),
                          value: isRandom,
                          onChanged: (bool value) async {
                            setRandom();

                            setState(() {
                              isRandom = value;
                            });

                            DbProvider().saveRandomState(value);
                          }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff372F2E),

                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 8),
                      child: Text(
                        "UnMute Music",
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        activeColor: Color(0xffFC5B33),
                        activeTrackColor: Color(0xff857674),
                        inactiveThumbColor: Color(0xffA7B2C7),
                        inactiveTrackColor: Color(0xffDCE0ED),
                        value: isUnMuted,
                        onChanged: (bool value) async {
                          setState(() {
                            isUnMuted = value;
                          });
                          DbProvider().saveUnMuteState(value);
                          setMusic();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff372F2E),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 8),
                      child: Text(
                        "On Double Tap",
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                          activeColor: Color(0xffFC5B33),
                          activeTrackColor: Color(0xff857674),
                          inactiveThumbColor: Color(0xffA7B2C7),
                          inactiveTrackColor: Color(0xffDCE0ED),
                          value: isDoubleTappedOn,
                          onChanged: (bool value) async {
                            if (!isDoubleTappedOn) {
                              requestPermission();
                            }

                            const permission = Permission.systemAlertWindow;

                            if (await permission.isGranted) {
                              setState(() {
                                isDoubleTappedOn = value;
                              });
                            } else {
                              setState(() {
                                isDoubleTappedOn = false;
                              });
                            }

                            DbProvider().saveDoubleTap(value);
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
