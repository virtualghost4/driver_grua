import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Take{

  final String endpoint =  "http://tesis-ubb-2018-01.us-east-1.elasticbeanstalk.com/api/";
  Map  data = new Map();
  Map mensajeResponse = new Map();
  Map finalizaResponse = new Map();
  Future<Map> take(String id, String precio, String idServicio, String idGrua) async{
    String token = await readCounter();
    print('dentro de take');
    print('llegaron idUser: $id, precio : $precio idServicio: $idServicio');
    print('idGrua: $idGrua');
    //print('token: $token');

    http.Response response = await http.patch(
      Uri.encodeFull(endpoint+'servicios/'+idServicio+'/take/'+id),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      body: {
        'monto': precio,
        'id_grua': idGrua,
      }
    );

    data =await jsonDecode(response.body);
    print(data.toString());
    return data;
  }

  Future updateDescripcion(String isAltaGama, String mensageDescripcion, String idServicio) async{
    String token = await readCounter();
    print('dentro de UpdateDescripcion Method');
    print('isAltagama: $isAltaGama');
    print('Descripcion: $mensageDescripcion');

    http.Response response = await http.patch(
      Uri.encodeFull(endpoint+'servicios/'+idServicio+'/describir'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      body: {
        'descripcion_chofer': mensageDescripcion,
        'alta_gama': isAltaGama,
      }
    );

    mensajeResponse = await jsonDecode(response.body);
    print(mensajeResponse.toString());
  }

  Future<List> obtenerGruas() async{
    List listadoGruas = new List();
    String token = await readCounter();

    http.Response response = await http.get(
      Uri.encodeFull('http://tesis-ubb-2018-01.us-east-1.elasticbeanstalk.com/api/gruaspiloto'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    listadoGruas = await jsonDecode(response.body);
    print('ListadoGruas: $listadoGruas');

    return listadoGruas;
  }

  Future finalizar(String idServicio) async{
    String token = await readCounter();
    print('dentro de finalizar');
    print('id del servicio: $idServicio');

    http.Response response = await http.get(
      Uri.encodeFull(endpoint+'servicios/'+idServicio+'/finalizar'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      
    );
    finalizaResponse = await jsonDecode(response.body);
    print(finalizaResponse.toString());

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

}