import 'package:driver_grua/services_page.dart';
import 'package:flutter/material.dart';
import 'package:driver_grua/maps_demo.dart';


class Detalle extends StatefulWidget {

  final Map data;
  Detalle(this.data);

  _DetalleState createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body:  Container(
       child: new Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           new Text(this.data["cliente_info"]["id"].toString()),
           new Text(this.data["cliente_info"]["nombre"].toString()+ ''+ this.data["cliente_info"]["ap_paterno"].toString()),
           new Text(this.data["cliente_info"]["celular"].toString()),
           new Text(this.data["cliente_info"]["rut"].toString()),
           new FlatButton(
             child: new Text('abrir mapa'),
             onPressed: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context)=> PlaceMarkerPage()));
             },
           ),
           new FlatButton(
             child: new Text('show info on log'),
             onPressed: (){
               print('button Pressed!');
               showMe();
             },
           )
         ]
       )
    ),
    );
  }
}