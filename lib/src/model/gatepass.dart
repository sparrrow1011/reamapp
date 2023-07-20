import 'dart:convert';

class GatePass{
  String? id;
  String? date_created;
  String? plate_number;
  String? residency_id = "";
  String? resident = "";
  String? resident_id = "";
  String? site_id = "";
  int? resident_type = 1;
  String? visitor = "";
  int? status = 0;
  String? token;
  Map? attr = {};

  GatePass(this.id, this.token,
      { this.date_created,  this.plate_number,  this.residency_id,
      this.resident, this.status, this.resident_id, this.attr, this.resident_type, this.visitor, this.site_id});

  factory GatePass.fromJson(Map<String, dynamic>? parsedJson) {
    return GatePass(parsedJson!['id'], parsedJson['token'],
      date_created: parsedJson['date_created'] ?? "",
      plate_number: parsedJson['plate_number'] ?? "",
      residency_id: parsedJson['residency_id'] ?? "",
      resident: parsedJson['resident'] ?? "",
        status: parsedJson['status'] ?? "",
      resident_id: parsedJson['resident_id'] ?? "",
        attr: parsedJson['attr'],
      resident_type: parsedJson['resident_type'] ?? 1,
      visitor: parsedJson['visitor'] ?? "",
      site_id: parsedJson['site_id'] ?? "",
        );
  }
//
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date_created": date_created,
      "plate_number": plate_number,
      "residency_id": residency_id ?? "",
      "resident":resident ?? "",
      "resident_id": resident_id ?? "",
      "site_id": site_id ?? "",
      "resident_type": resident_type ?? 0,
      "attr": attr,
      "visitor": visitor ?? "",
      "status": status ?? 0,
      "token": token ?? "",
    };
  }

}
