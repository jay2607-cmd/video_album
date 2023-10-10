
import 'package:hive/hive.dart';
import '../database/save.dart';


class Boxes{
  static Box<Save> getData() => Hive.box<Save>("saveCategories");
}