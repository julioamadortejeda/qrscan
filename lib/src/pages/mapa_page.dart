import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:qrscan/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController mapController = new MapController();
  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scanModel.getLatLng(), 12);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scanModel),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scanModel) {
    return new FlutterMap(
      mapController: mapController,
      options: MapOptions(center: scanModel.getLatLng(), zoom: 12),
      layers: [_crearMapa(), _crearMarcadores(scanModel)],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiamNhbWFkb3IiLCJhIjoiY2s0eGdtc3B0MDBxdjNubWJrbjZibTZtbCJ9.f7jD90EeigMGg7t6R7t9eQ',
          'id': 'mapbox.$tipoMapa', //streets, dark, light, outdoors, satellite
        });
  }

  _crearMarcadores(ScanModel scanModel) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scanModel.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //streets, dark, light, outdoors, satellite
        if (tipoMapa == 'streets') {
          tipoMapa = 'dark';
        } else if (tipoMapa == 'dark') {
          tipoMapa = 'light';
        } else if (tipoMapa == 'light') {
          tipoMapa = 'outdoors';
        } else if (tipoMapa == 'outdoors') {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }

        setState(() {});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
