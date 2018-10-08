import 'package:flutter/material.dart';
import 'package:driver_grua/maps_demo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:driver_grua/services/take.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Detalle extends StatefulWidget {

  Detalle({Key key,@required this.data}) : super(key : key);
  final Map data;

  @override
  _DetalleState createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {

final valorController = TextEditingController();
final mensajeController = TextEditingController();

  GoogleMapController mapController;
  //Marker _selectedMarker;

  void showMe(){
    print(widget.data);
  }

  void _costumerLocation() {
    mapController.addMarker(MarkerOptions(
      position: LatLng(-36.8189, -73.0503),
      infoWindowText: InfoWindowText('Origen', 'Transportes Telleo'),
    ));
  }

  void _costumerDestination() {
    mapController.addMarker(MarkerOptions(
      position: LatLng(-36.8080, -73.0504),
      infoWindowText: InfoWindowText('Destino', 'Transportes Telleo'),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
      setState(() { mapController = controller; });
      this._costumerLocation();
      this._costumerDestination();
    }

 
  
  Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();
      print(directory);
      return directory.path;
  }

  Future<File> get _idFile async {
    final path = await _localPath;
    return File('$path/id.txt');
  }

  Future<String> readId() async {
      try {
        final file = await _idFile;

        // Read the file
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If we encounter an error, return 0
        return 'no se detecta id';
      }
    }

  Future<String> showID() async{
    String idReal;
    idReal =  await readId(); 
    print('idRead: $idReal');
    return idReal;
  }

  Future<String> showValor() async {
    String value = valorController.text;
    if(value==''){
      print('Valor Vacio');
    }else{
      print('valor ingresado es: $value');
    }
    return value;
  }

  Future<String> showDescripcion() async {
    String descripcion = mensajeController.text;
    if(descripcion==''){
      print('Descripcion Vacia');
    }else{
      print('Descripcion ingresada: $descripcion');
    }
    return descripcion;
  }

  Future  performPrecio() async{

    String idUser = await showID();
    String precio = await showValor();
    String idServicio = widget.data["id"].toString();
    String idGrua = widget.data["id_grua"].toString();

    Map res = await Take().take(idUser, precio, idServicio, idGrua);
    
  }

  Future performDescripcion(int isAltaGama) async{
    String descripcion = await showDescripcion();
    String idService = widget.data["id"].toString();
    String altaGama = isAltaGama.toString();
    print('Descripcion es: $descripcion');
    await Take().updateDescripcion(altaGama, descripcion, idService);

  }

  void errorToast() {
    Fluttertoast.showToast(
        msg: "Error al tomar Servicio",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1
    );
  }
  void successfulToast() {
    Fluttertoast.showToast(
        msg: "Servicio Reclamado",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1
    );
  }

  bool _value = false;

  void _onChanged(bool value){
    setState(() {
          _value = value;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: new AppBar(
        title: new Text("Detalle Cliente"),
      ),
      body: new ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          new Card(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new SizedBox(
                  width: 1.00,
                  child: new Icon(
                  Icons.account_box
                  ),
                  
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text('ID: '),
                    new Text('Nombre: '),
                    new Text('Rut: '),
                    new Text('Telefono Fijo: '),
                    new Text('Celular: '),
                    new Text('email: '),
                  ],
                ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(widget.data["id"].toString()),
                    new Text(widget.data["cliente_info"]["nombre"].toString()+ ' '+ widget.data["cliente_info"]["ap_paterno"].toString()),
                    new Text(widget.data["cliente_info"]["rut"].toString()),
                    new Text(widget.data["cliente_info"]["telefono_fijo"].toString()),
                    new Text(widget.data["cliente_info"]["celular"].toString()),
                    new Text(widget.data["cliente_info"]["email"].toString()),
                  ]
                ),
              ],
            ),
          ),
          new Card(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new SizedBox(
                  width: 1.00,
                  child: new Icon(
                  Icons.directions_car
                  ),
                  
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text('ID: '),
                    new Text('Patente: '),
                    new Text('Marca: '),
                    new Text('Modelo: '),
                    new Text('Color: '),
                  ],
                ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(widget.data["vehiculo_info"]["id"].toString()),
                    new Text(widget.data["vehiculo_info"]["patente_vehiculo"].toString()),
                    new Text(widget.data["vehiculo_info"]["marca"].toString()),
                    new Text(widget.data["vehiculo_info"]["modelo"].toString()),
                    new Text(widget.data["vehiculo_info"]["color"].toString()),
                  ]
                ),
              ],
            ),
          ),
          new Card(
            child: new Column(
              children: <Widget>[
                new Text('Ingrese Valor de Servicio'),
                new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new SizedBox(
                  width: 1.00,
                  child: new Icon(
                  Icons.attach_money
                  ),
                  
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                   SizedBox(
                     width: 80.0,
                     child: new TextField(
                       controller: valorController,
                       decoration: InputDecoration(
                         hintText: 'Ingrese Valor',
                       ),
                     ),
                   )
                  ],
                ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Send'),
                      onPressed: (){
                        performPrecio();
                        
                        
                      },
                    ),
                  ]
                ),
              ],
            ),
              ]
            )
          ),
          new Card(
            
          ),
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new TextField(
                    controller: mensajeController,
                    decoration: InputDecoration(
                       hintText: 'Ingrese Descripcion',
                     ),
                   ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text('¿Es alta Gama?'),
                      new Switch(
                        value: _value , onChanged: (bool value){_onChanged(value);},
                      ),
                      new RaisedButton(
                        child: 
                        new Text('Enviar Descripcion'),
                        onPressed: (){
                          
                          if(_value){
                            performDescripcion(1);
                          }else{
                            performDescripcion(0);
                          }
                        },
                      )
                    ],
                  ),
                  new RaisedButton(
                    child: 
                      new Text('abrir mapa'),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> PlaceMarkerPage()));
                    },
                  ),
                  new FlatButton(
                    child:
                    new Text('Show ID'),
                    onPressed: (){
                      showID();
                      
                    },
                  ),
                new FlatButton(
                  child: new Text('show info on log'),
                  onPressed: (){
                    print('button Pressed!');
                    showMe();
                  },
                ),
                new Column(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 400.0,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      options: GoogleMapOptions(
                        cameraPosition: const CameraPosition(
                          target: LatLng(-36.8189, -73.0503),
                          zoom: 11.0,
                        )
                      )
                    ),
                  ),
                ),
              ]
            ),
              ]
            )
          ),
        ],
      )
    );
  }


    
}