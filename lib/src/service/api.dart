import 'package:dio/dio.dart';
import '../model/site.dart';
import '../service/authdata.dart';

class Api {
  Dio http = new Dio();

  // String Host = 'http://10.0.2.2:8000/api/';
  // String Host = 'http://192.168.86.211:8000/api/';
  String apiSchema = 'https://';
  String url = 'qonvej.com';
  String path = '/api/';
  String Host = '';
  // String Host = 'http://192.168.43.248:8000/api /';
  // String Host = 'http://192.168.100.71:8000/api/';


  Api()  {

    http.options = new BaseOptions(headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8'
    });
  }
  genHostUrl() async {
    Site? domain = await AuthData.getSite();
    String? getUrl = url;
    if(domain != null){
      getUrl = domain.subdomain! + '.' + getUrl;
    }
    String getHost = apiSchema+ getUrl + path;
    return getHost;
  }
  checkAuth() async {
    Host = await genHostUrl();
    http.options.baseUrl = Host;
    String? token = await AuthData.getToken();
    if (token != null) {
      http.interceptors.clear();
      http.interceptors.add(
          InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
        // Do something before request is sent
        print(token);
        options.headers["cookie"] =  token;
        return handler.next(options);
      }, onResponse: (Response response, handler) {
        // Do something with response data
        if (response.statusCode == 403) {
          print(response.data);
//          print('unthenticated');
//           AuthData.Logout();
        }
//        print(response);
        return handler.next(response); // continue
      }, onError: (DioError error, handler) async {
        // Do something with response error
//        print(error.response);
        if (error.response?.statusCode == 403) {
//            print('unthenticated');
        print(error.message);
//           AuthData.Logout();
        } else {
          return handler.next(error);
        }
      }));
    }
  }

  Future<Map> get(String path,
      {Map<String, dynamic>? body, Options? options}) async {

    await checkAuth();
    print(Host);
    print(path);
//    print(body);
    try {
      Response response =
          await http.get(path, queryParameters: body, options: options);

      print(response);
      return {
        'status': response.statusCode,
        'message': response.statusMessage,
        'data': response.data,
        'header': response.headers
      };
    } on DioError catch (e) {
      print(e.response);
      Map err = e.response!.data;
      String errMessage = "An error occurred while making contacting server!!";
      if(err.containsKey('error')){
        errMessage = err['error'];
      }
      Map<String, dynamic> ret = {
        'status': e.response!.statusCode,
        'message': errMessage,
        'data': []
      };
      return ret;
    } catch (e) {
      print('error');
      print(e);
      Map<String, dynamic> ret = {
        'status': 405,
        'message': "An error occurred while making contacting server!!",
        'data': []
      };
      return ret;
    }
  }

  Future<Map> post(String path,
      {Map<String, dynamic>? body, Options? options}) async {

    await checkAuth();
    print(Host);
    print(path);
    try {
      Response response = await http.post(path, data: body, options: options);
      print(response);
      return {
        'status': response.statusCode,
        'message': response.statusMessage,
        'data': response.data,
        'header': response.headers
      };
    } on DioError catch (e) {
      print(e.response);

      Map err = e.response!.data;
      String errMessage = "An error occured while making contacting server!!";
      if(err.containsKey('error')){
        errMessage = err['error'];
      }
      Map<String, dynamic> ret = {
        'status': e.response!.statusCode,
        'message': errMessage,
        'data': []
      };
      return ret;
    } catch (e) {
//print('error');
      Map<String, dynamic> ret = {
        'status': 405,
        'message': "An error occurred while contacting server!!",
        'data': []
      };
      return ret;
    }
  }


Future<Map> delete(String path,
      {Map<String, dynamic>? body, Options? options}) async {

    await checkAuth();
    print(Host);
    print(path);
    try {
      Response response = await http.delete(path, data: body, options: options);
      print(response);
      return {
        'status': response.statusCode,
        'message': response.statusMessage,
        'data': response.data,
        'header': response.headers
      };
    } on DioError catch (e) {
      print(e.response);

      Map err = e.response!.data;
      String errMessage = "An error occured while making contacting server!!";
      if(err.containsKey('error')){
        errMessage = err['error'];
      }
      Map<String, dynamic> ret = {
        'status': e.response!.statusCode,
        'message': errMessage,
        'data': []
      };
      return ret;
    } catch (e) {
//print('error');
      Map<String, dynamic> ret = {
        'status': 405,
        'message': "An error occurred while contacting server!!",
        'data': []
      };
      return ret;
    }
  }

  Future<Map> login(String path,
      {Map<String, dynamic>? body, Options? options}) async {
    await checkAuth();
    try {
      Response response = await http.post(path, data: body, options: options);
      print(response);
      getCookie(response);
      return {
        'status': response.statusCode,
        'message': response.statusMessage,
        'data': response.data,
        'header': response.headers
      };
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.response);
      Map<String, dynamic> ret = {
        'status': 405,
        'message': "An error occurred while making contacting server!!",
        'data': []
      };
      return ret;
    } catch (e) {
//print('error');
      Map<String, dynamic> ret = {
        'status': 405,
        'message': "An error occurred while contacting server!!",
        'data': []
      };
      return ret;
    }
  }

  String? getCookie(Response response) {
    String? rawCookie = response.headers.value("set-cookie");
    String resultCookie = "";
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      resultCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      index = resultCookie.indexOf('=');
      resultCookie = (index == -1) ? rawCookie : rawCookie.substring(index+1, resultCookie.length);
      return resultCookie;
    }
    return null;
  }
}
