import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class Services{


List data = new List();


Future<List> fetchServices() async {

  print('dentro de servicios');
  String token = await readCounter();
  print('token: $token');
  http.Response res = await http.get(
    'http://tesis-ubb-2018-01.us-east-1.elasticbeanstalk.com/api/servicios',
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
  );
  data = jsonDecode(res.body);
  print(data);
  return data;
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