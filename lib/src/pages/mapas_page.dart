import 'package:flutter/material.dart';

//Custom imports
import 'package:qrscan/src/bloc/scans_bloc.dart';
import 'package:qrscan/src/models/scan_model.dart';

class MapasPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        //initialData: [],
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(
              child: Text('No hay información'),
            );
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (DismissDirection direccion) =>
                  scansBloc.borrarScan(scans[index].id),
              child: ListTile(
                leading: Icon(Icons.cloud_queue,
                    color: Theme.of(context).primaryColor),
                title: Text(scans[index].valor),
                subtitle: Text('ID: ${scans[index].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ),
            ),
          );
        });
  }
}
