import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark().copyWith(
      // Customize the dark theme properties here
      primaryColor: Colors.blue,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Album',
      theme: ThemeData(
        fontFamily: "Montserrat",

      ),
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }
}
