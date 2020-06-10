
import 'dart:io';
import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../models/pet.dart';

class HTTPSingleton {

  /**
   * Singleton
   */
  ///
  static final HTTPSingleton _singleton = HTTPSingleton._internal();

  factory HTTPSingleton() {
    return _singleton;
  }

  HTTPSingleton._internal() {
    path = GlobalConfiguration().getString("url");
    routes = GlobalConfiguration().get("routes");
  }

  /**
   * Class definition
   */
  ///
  String path;
  Map<String, dynamic> routes;

  Future<int> savePet(Pet pet) async {
    var petMap = pet.toJson(local: false);

    var body = Map<String, String>();
    for (var key in petMap.keys)
      body[key] = (petMap[key] == null) ? "" : petMap[key].toString();

    var response = await http.post(Uri.http(path, routes['newpet']),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"}
        );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      pet.id = res['pet_id'];
      return res['status'] as int;
    } else {
      return ;
    }
  }

  Future<int> editPet(Pet pet) async {
    var petMap = pet.toJson(local: false);

    var body = Map<String, String>();
    for (var key in petMap.keys)
      body[key] = (petMap[key] == null) ? "" : petMap[key].toString();

    var response = await http.post(Uri.http(path, routes['editpet']),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"}
    );

    var res = jsonDecode(response.body);
    return res['status'] as int;
  }


  Future<int> savePhoto(Pet pet, String photo) async {
    var imgBytes = File(photo).readAsBytesSync();
    print("Img bytes type: ${imgBytes.runtimeType}");

    var imgB64 = base64.encode(imgBytes);

    var response = await http.post(Uri.http(path, routes['newphoto/${pet.id}']),
        body: imgB64,
//        headers: {"Content-Type": "application/json"}
    );

    var res = jsonDecode(response.body);

    // TODO: Mark photo as sent

    return res['status'] as int;
  }
}








