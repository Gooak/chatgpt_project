import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class SqlDataBase{
  static final SqlDataBase instance = SqlDataBase._instance();

  Database? _database;

  SqlDataBase._instance(){
    _initDataBase();
  }

  factory SqlDataBase() {
    return instance;
  }

  Future<Database> get datebase async{
    if(_database != null) return _database!;
    await _initDataBase();
    return _database!;
  }
  Future<void> _initDataBase()async{
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'mychatgpt.db');
    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate); //데이터베이스가 없을때 생성 onCreate
  }

  void _databaseCreate(Database db, int version)async{
    await db.execute('''
      create table ${Contents.tableName} (
        ${ChatFields.id} integer primary key autoincrement,
        ${ChatFields.text} text not null,
        ${ChatFields.bottext} text,
        ${ChatFields.date} text not null
      )
    ''');
  }

  void closeDateBase()async{
    if(_database!=null) await _database!.close();
  }

  static Future<Contents> create(Contents contents) async{
    var db= await SqlDataBase().datebase;

    var id = await db.insert(Contents.tableName, contents.toJson());
    return contents.clone(id: id);
  }

  static Future<List<Contents>> getList()async{
    var db= await SqlDataBase().datebase;
    var result = await db.query(Contents.tableName,columns: [
      ChatFields.id,
      ChatFields.text,
      ChatFields.bottext,
      ChatFields.date,
    ]);
    return result.map((data){
      return Contents.fromJson(data);
    }).toList();
  }
    void delete(String contents) async {
    var db= await SqlDataBase().datebase;
    await db.delete(
      Contents.tableName,
      where: "text = ?",
      whereArgs: [contents],
    );
  }
}