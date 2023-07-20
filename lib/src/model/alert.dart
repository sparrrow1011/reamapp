import 'dart:convert';

class Alert{
  String? id;
  String? resident_id = "";
  String? site_id = "";
  String? name = "";
  String? Address = "";
  String? phone_number = "";
  int? status = 0;
  String? time_logged = "";
  String? time_responded = "";
  Map? attr = {};

  Alert(this.id,
      { this.time_logged,  this.time_responded, this.status, this.resident_id, this.attr, this.site_id, this.name, this.Address, this.phone_number});

  factory Alert.fromJson(Map<String, dynamic>? parsedJson) {
    return Alert(parsedJson!['id'],
      time_logged: parsedJson['time_logged'] ?? "",
      time_responded: parsedJson['time_responded'] ?? "",
        status: parsedJson['status'] ?? "",
      resident_id: parsedJson['resident_id'] ?? "",
        attr: parsedJson['attr'],
      site_id: parsedJson['site_id'] ?? "",
      name: parsedJson['name'] ?? "",
      Address: parsedJson['Address'] ?? "",
      phone_number: parsedJson['phone_number'] ?? "",
        );
  }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "date_created": date_created,
//       "plate_number": plate_number,
//       "residency_id": residency_id ?? "",
//       "resident":resident ?? "",
//       "resident_id": resident_id ?? "",
//       "site_id": site_id ?? "",
//       "resident_type": resident_type ?? 0,
//       "attr": attr,
//       "visitor": visitor ?? "",
//       "status": status ?? 0,
//       "token": token ?? "",
//     };
//   }

}
