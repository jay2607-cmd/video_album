import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF0F1F5),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                      child: Text(
                        "Allow Random Wallpaper",
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                          activeColor: Color(0xff4F6DDC),
                          activeTrackColor: Color(0xffDCE0ED),
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
                      color: Color(0xffF0F1F5),
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
                        activeColor: Color(0xff4F6DDC),
                        activeTrackColor: Color(0xffDCE0ED),
                        inactiveTrackColor: Color(0xffDCE0ED),
                        inactiveThumbColor: Color(0xffA7B2C7),
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
                      color: Color(0xffF0F1F5),
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
                          activeColor: Color(0xff4F6DDC),
                          activeTrackColor: Color(0xffDCE0ED),
                          inactiveThumbColor: Color(0xffA7B2C7),
                          inactiveTrackColor: Color(0xffDCE0ED),
                          value: isDoubleTappedOn,
                          onChanged: (bool value) async {
                            setState(() {
                              isDoubleTappedOn = value;
                            });
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
