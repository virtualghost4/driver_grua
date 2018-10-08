import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Auth {


var endpoint = "http://tesis-ubb-2018-01.us-east-1.elasticbeanstalk.com/api/login";


Map  data = new Map();


 Future<int> getData(String email, String password) async {
   print('dentro de GetData');
   print('llegaron $email y $password');
    http.Response res = await http.post(
      Uri.encodeFull(endpoint),
      body: {
        'email': email,
        'password': password,
      }
    );
    
    data = jsonDecode(res.body);
    print(data["user"]);
    
    
    print(res.statusCode.toString());
    if(res.statusCode==200){
      writeCounter(data["access_token"]);
      writeId(data["user"]["id"].toString());
      

      return 200;
    }else{
      return 401;
    }
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return directory.path;
  }

  Future<String> get _localPathId async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return directory.path;
  }

//crea archivo con token
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
  //crea archivo con id
  Future<File> get _idFile async {
    final path = await _localPathId;
    return File('$path/id.txt');
  }

//escribe archivo con token
  Future<File> writeCounter(String token) async {
    final file = await _localFile;
  
    // Write the file
    return file.writeAsString('$token');
  }

//escribe archivo con id
  Future<File> writeId(String id) async {
    final file = await _idFile;
  
    // Write the file
    return file.writeAsString('$id');
  }

//lee archivo con id
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

//lee archivo con id
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

}