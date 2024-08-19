


//データベースとのやり取りを、別クラスにした
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String modelTable = 'model_table';
  String colId = 'id';
  String col0101 = 'height';
  String col0102 = 'weight';
  String col103 = 'waist';
  String colOnTheDay = 'on_the_day';
  String colPriority = 'priority';
  String colDate = 'date';


  DatabaseHelper._createInstance(); //
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}models.db';
    var modelsDatabase = await openDatabase(
        path,
        version: 3,
        onCreate: _createDb,);
    return modelsDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $modelTable('
        ' $colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        ' $col0101 TEXT, $col0102 TEXT, $col103 TEXT,'
        ' $colOnTheDay TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getModelMapList() async {
    Database db = await database;
    var result = await db.query(modelTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertModel(Model models) async {
    Database db = await database;
    var result = await db.insert(modelTable, models.toMap());
    return result;
  }

  Future<int> updateModel(Model model) async {
    var db = await database;
    var result = await db.update(modelTable, model.toMap(),
        where: '$colId = ?', whereArgs: [model.id]);
    return result;
  }

  Future<int> deleteModel(int id) async {
    var db = await database;
    int result =
    await db.rawDelete('DELETE FROM $modelTable WHERE $colId = $id');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $modelTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Model>> getModelList() async {
    var modelMapList = await getModelMapList(); // Get 'Map List' from database
    int count =
        modelMapList.length; // Count the number of map entries in db table
    List<Model> modelList = <Model>[];
    for (int i = 0; i < count; i++) {
      modelList.add(Model.fromMapObject(modelMapList[i]));
    }
    return modelList;
  }
}
