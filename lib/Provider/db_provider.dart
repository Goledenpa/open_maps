import 'package:flutter/material.dart';
import 'package:open_maps/Model/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static const _dbName = 'maps.db';
  final _versionDB = 1;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Database database = await openDatabase(
        join(await getDatabasesPath(), _dbName),
        version: _versionDB, onCreate: (Database database, int version) async {
      await database.execute('''
            CREATE TABLE "Markers" (
            "Id" INTEGER,
            "Title" TEXT NOT NULL,
            "Description" TEXT NOT NULL,
            "Latitude" NUMERIC NOT NULL,
            "Longitude" NUMERIC NOT NULL,
            PRIMARY KEY("Id" AUTOINCREMENT)
            );
          ''');
    });
    return database;
  }

  Future<List<MarkerMap>> getMarkers() async {
    try {
      final db = await database;
      final res = await db.query('Markers', orderBy: 'Id');
      return res.map((e) => MarkerMap.fromMap(e)).toList();
    } catch (e) {
      debugPrint('GET MARKERS: $e');
      return [];
    }
  }

  void addMarker(MarkerMap value) async {
    try {
      final db = await database;
      final res = await db.insert('Markers', value.toMap());
    } catch (e) {
      debugPrint('ADD MARKER: $e');
    }
  }
}
