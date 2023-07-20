// ignore_for_file: file_names

import '../service/api.dart';
import '../model/response.dart';

import '../util/helper.dart';

class AccountService {

  statusList(Map body, List param) async {
    String path = 'db/ResidentBillingSummary';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  paymentList(Map body) async {
    String path = 'db/AccountHistory';
    // path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  pendingList(Map body) async {
    String path = 'db/PaymentPending';
    // path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  getDues(List param) async {
    String path = 'ctl/residentDues';
    path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  PaymentForm(Map body) async {
    String path = 'db/PaymentForm/new';
    // path += appendParam(param);
    Api api = Api();
    Map data = await api.get(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  PaymentFormSubmit(Map body) async {
    String path = 'db/PaymentForm/new';
    // path += appendParam(param);
    Api api = Api();
    Map data = await api.post(path, body: Map<String,dynamic>.from(body));
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  paystackKey() async {
    String path = 'ctl/pub/1';
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  flutterwaveKey() async {
    String path = 'ctl/pub/3';
    Api api = Api();
    Map data = await api.get(path);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  initPaystack(Map<String, dynamic> body) async {
    String path = 'ctl/paystack';
    Api api = new Api();
    Map data = await api.post(path, body:body );
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }
  makePayment(Map<String, dynamic> body) async {
    String path = 'db/PaymentForm/new';
    Api api = new Api();
    Map data = await api.post(path, body:body );
//     print(data);
    return Response.fromJson(Map<String, dynamic>.from(data));
  }

  // {
  // "id": "",
  // "resident_id": "c1a75t8cvcqjp069j6e0",
  // "date_trx": "2021-09-29",
  // "description": "",
  // "amount": "30.00",
  // "pay_mode": 2,
  // "dues": [
  // {
  // "due_id": "c1qo7u8cvcqlsj71v2i0",
  // "name": "Ikeja Assoc bill",
  // "amount": "30"
  // }
  // ],
  // "attr": {
  // "teller_no": "0898493",
  // "bank_name": "Zenith Bank",
  // "date": "2021-09-29"
  // },
  // "provider": {
  // "value": 2,
  // "name": "Bank Transaction"
  // },
  // "res_id": "c1a75t8cvcqjp069j6e0",
  // "email": "pascal.ahmed@gmail.com",
  // "name": "Pascal Ahmedd",
  // "date_created": "",
  // "_model": "PaymentForm",
  // "_list": "AccountHistory-$limit:10,$offset:0,$order:date_trx desc"
  // }

}
