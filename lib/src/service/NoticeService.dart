import '../service/api.dart';
import '../model/response.dart';
import '../util/helper.dart';

class NoticeService {

  noticeList(Map body) async {
    String path = 'db/ActiveNotice';
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  noticeBoard( List param) async {
    String path = 'db/NoticeBoard';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
}
