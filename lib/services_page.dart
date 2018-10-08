import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:driver_grua/detalle_cliente.dart';
//import 'package:driver_grua/customer_details.dart';



class ServicePage extends StatefulWidget {

  _ServicePageState createState() => _ServicePageState();
}


class _ServicePageState extends State<ServicePage> {

  List data = new List();

  Future<String> fetchServices() async {

    print('dentro de servicios');
    String token = await readCounter();
   
    
    print('token: $token');
    http.Response res = await http.get(
      'http://tesis-ubb-2018-01.us-east-1.elasticbeanstalk.com/api/servicios',
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    this.setState(() {
      data = json.decode(res.body);
    });
    print(data);
    return 'Success';
  }
  
  
    Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();
      print(directory);
      return directory.path;
    }

    Future<File> get _localFile async {
      final path = await _localPath;
      return File('$path/counter.txt');
    }


    Future<String> readCounter() async {
      try {
        final file = await _localFile;

        // Read the file
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If we encounter an error, return 0
        return 'no';
      }
    }

    @override
      void initState() {
        super.initState();
        this.fetchServices();
    }

    @override
    Widget build(BuildContext context) {    

      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Servicios Pendientes"),
        ),
        body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('id servicio:'),
                      new Text('Cliente:'),
                      new Text('Patente Vehiculo:'),
                      new Text('telefono:'),
                    ]
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(data[index]["id"].toString()),
                      new Text(data[index]["cliente_info"]["nombre"].toString()),
                      new Text(data[index]["vehiculo_info"]["patente_vehiculo"].toString()),
                      new Text(data[index]["cliente_info"]["celular"].toString()),
                    ],
                  ),
                  new Column(
                    
                    children: <Widget>[
                      new FlatButton(
                        color: Colors.redAccent,
                        child: new Text('Tomar'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Detalle(data: data[index],)),
                            //MaterialPageRoute(builder: (context) => ExpansionTileSample()),
                          );
                          //print(data[index]["id"]);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
  );
      
      
    }

}