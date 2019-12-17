import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrscan/src/models/scan_model.dart';
export 'package:qrscan/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  //Inicializar base de datos
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY, '
          ' tipo TEXT, '
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  //Crear registros
  
  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }

  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO  Scans (id, tipo, valor) "
      "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );

    return res;
  }

  //Selects - Obtener info

  Future<ScanModel> getScanId(int id) async {
    final db =  await database;
    final res =  await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan) => ScanModel.fromJson(scan)).toList()
                          : [];

    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE TIPO='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                          ? res.map((scan) { ScanModel.fromJson(scan);}).toList()
                          : [];

    return list;
  }

  //Update

  Future<int> actualizarScanPorId(ScanModel scanModel) async {
    final db = await database;
    final res = await db.update('Scans', scanModel.toJson(), where: 'id = ?', whereArgs: [scanModel.id]);

    return res;
  }

  //Delete
  Future<int> borrarScanPorId(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> borrarAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');

    return res;
  }
}
