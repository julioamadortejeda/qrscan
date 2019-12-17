import 'package:flutter/material.dart';

//import 'package:qrcode_reader/qrcode_reader.dart';

//Custom imports
import 'package:qrscan/src/bloc/scans_bloc.dart';
import 'package:qrscan/src/models/scan_model.dart';

import 'package:qrscan/src/pages/direcciones_page.dart';
import 'package:qrscan/src/pages/mapas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarAllScans,
          )
        ],
      ),
      body: _llamarPagina(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _scannQR();
        },
      ),
    );
  }

  Widget _llamarPagina(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
        break;
      case 1:
        return DireccionesPage();
        break;
      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions), title: Text('Direcciones')),
      ],
    );
  }

  _scannQR() async {
    //https://fernando-herrera.com
    //geo:40.724233047051705,-74.00731459101564

    String futureString = 'https://fernando-herrera.com';
    // try {
    //   futureString = await new QRCodeReader().scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
    }
  }
}
