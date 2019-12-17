import 'dart:async';

//Custom imports}
import 'package:qrscan/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();
  final _scansController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  dispose() {
    _scansController?.close();
  }

  agregarScan(ScanModel scanModel) async {
    await DBProvider.db.nuevoScan(scanModel);
    obtenerScans();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  borrarScan(int id) async {
    await DBProvider.db.borrarScanPorId(id);
    obtenerScans();
  }

  borrarAllScans() async {
    await DBProvider.db.borrarAll();
    obtenerScans();
  }
}
