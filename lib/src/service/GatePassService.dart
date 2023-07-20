// ignore_for_file: file_names

import '../service/api.dart';
import '../model/response.dart';
import '../util/helper.dart';

class GatePassService {

  gatePassList(Map body) async {
    String path = 'db/GatePassList';
    // path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  getGatePass(List param) async {
    String path = 'db/GatePass';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  getGatePassToken(List param) async {
    String path = 'db/GatePass/token';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  createGatePass(Map body) async {
    String path = 'db/GatePass/new';
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  editGatePass(Map body, List param) async {
    String path = 'db/GatePass';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  deleteGatePass(Map body, List param) async {
    String path = 'db/GatePass';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.delete(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  getGatePassStatus(Map body, List param) async {
    String path = 'db/GatePass';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

}
