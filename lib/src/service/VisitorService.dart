import '../service/api.dart';
import '../model/response.dart';

class VisitorService {

  visitorList(Map body) async {
    String path = 'db/VisitorList';
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
}
