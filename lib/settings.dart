import 'package:flutter/material.dart';
import 'package:video_album/provider/db_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isRandom = false;
  bool isHideCreationDate = false;
  bool _secured = false;

  @override
  void initState() {
    super.initState();

    DbProvider().getRandomState().then((value) {
      setState(() {
        isRandom = value;
      });
    });

    DbProvider().getDoubleTap().then((value) {
      setState(() {
        isHideCreationDate = value;
      });
    });

    DbProvider().getAuthState().then((value) {
      setState(() {
        _secured = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          vertical: 24.0, horizontal: 8),
                      child: Text(
                        "Allow Random Wallpaper",
                      ),
                    ),
                    trailing: Switch(
                        activeColor: Color(0xff4F6DDC),
                        activeTrackColor: Color(0xffDCE0ED),
                        inactiveThumbColor: Color(0xffA7B2C7),
                        inactiveTrackColor: Color(0xffDCE0ED),
                        value: isRandom,
                        onChanged: (bool value) async {
                          setState(() {
                            isRandom = value;
                          });

                          DbProvider().saveRandomState(value);
                        }),
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
                          value: isHideCreationDate,
                          onChanged: (bool value) async {
                            setState(() {
                              isHideCreationDate = value;
                            });
                            DbProvider().saveDoubleTap(value);
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        "Secure Account",
                      ),
                      subtitle: Text(
                        "Enable two factor authentication",
                      ),
                      trailing: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          activeColor: Color(0xff4F6DDC),
                          activeTrackColor: Color(0xffDCE0ED),
                          inactiveTrackColor: Color(0xffDCE0ED),
                          inactiveThumbColor: Color(0xffA7B2C7),
                          value: _secured,
                          onChanged: (bool value) async {

                          },
                        ),
                      ),
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
