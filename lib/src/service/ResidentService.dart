import '../service/api.dart';
import '../model/response.dart';
import '../util/helper.dart';

class ResidentService {

  residentList(Map body, List param) async {
    String path = 'db/ResidentView';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  getResident(List param) async {
    String path = 'db/ResidentView';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  createResident(Map body) async {
    String path = 'db/Resident/new';
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  editResident(Map body, List param) async {
    String path = 'db/Resident';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  deleteResident(Map body, List param) async {
    String path = 'db/Resident';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.delete(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
}
