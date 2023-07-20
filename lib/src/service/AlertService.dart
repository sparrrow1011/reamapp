import '../service/api.dart';
import '../model/response.dart';
import '../util/helper.dart';

class AlertService {

  newAlert(Map body) async {
    String path = 'resident/alert';
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  getLastAlert() async {
    String path = 'resident/get_last_alert';
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  alertList(Map body) async {
    String path = 'resident/list_alerts';
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  updateAlert(Map body, List param) async {
    String path = 'resident/alert';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
}
