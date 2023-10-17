import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home_page.dart';
import 'database/save.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.initFlutter();

  Hive.registerAdapter(
    SaveAdapter(),
  );

  await Hive.openBox("InsideList");

  await Hive.openBox<Save>("saveCategories");
  requestPermission();
  runApp(const MyApp());
}

Future<void> requestPermission() async {
  final permission = Permission.systemAlertWindow;

  if (await permission.isDenied) {
    await permission.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Album',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}
