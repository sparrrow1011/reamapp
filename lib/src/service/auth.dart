import '../service/api.dart';
import '../model/response.dart';

class Auth {
  appendParam(List param) {
    String urlParam = '';
    for (String e in param) {
      urlParam += '/' + e;
    }
    return urlParam;
  }

  Register(Map<String, dynamic> body) async {
    String path = 'ctl/register_newresident';
    Api api = Api();
    Map data = await api.post(path, body: body);
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  Login(Map body, List param) async {
    String path = 'auth/login';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String, dynamic>.from(body));
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  EstateCode(List param) async {
    String path = 'ctl/association/site_code';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  Logout() async {
    String path = 'auth/logout';
    Api api = Api();
    Map data = await api.post(path);
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  Forgot(Map body) async {
    String path = 'forgot';
    Api api = new Api();
    Map data = await api.post(path, body: Map<String, dynamic>.from(body));
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  Verify(Map body) async {
    String path = 'verify';
    Api api = new Api();
    Map data = await api.post(path, body: Map<String, dynamic>.from(body));
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  Reset(Map body) async {
    String path = 'reset';
    Api api = new Api();
    Map data = await api.post(path, body: Map<String, dynamic>.from(body));
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  saveUser(Map body) async {
    String path = 'saveuser';
    Api api = new Api();
    Map data = await api.post(path, body: Map<String, dynamic>.from(body));
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  getDashboard() async {
    String path = 'resident/dashboard';
    Api api = new Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  visitorList(Map body) async {
    String path = 'db/VisitorList';
    Api api = Api();
    Map data = await api.get(path, body: Map<String, dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
}
