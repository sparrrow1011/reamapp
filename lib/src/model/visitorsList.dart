import 'dart:convert';

class VisitorList{
  String? id;
  String? date_created;
  String? date_arrival;
  String? name;
  String? vehicle_number = "";
  String? arrival_time = "";
  String? departure_time = "";
  int? registration_type = 0;
  int? status = 0;
  String? resident_id;
  String? unit_id;
  String? security_id;
  String? resident;
  String? security;
  Map? attr = {};

  VisitorList(this.id, this.name,
      { this.date_arrival,  this.vehicle_number,  this.date_created,
      this.arrival_time, this.status, this.departure_time, this.attr, this.registration_type,
      this.resident_id, this.unit_id, this.security_id, this.resident, this.security});

  factory VisitorList.fromJson(Map<String, dynamic>? parsedJson) {
    return VisitorList(parsedJson!['id'], parsedJson['name'],
      date_arrival: parsedJson['date_arrival'] ?? "",
      vehicle_number: parsedJson['vehicle_number'] ?? "",
      date_created: parsedJson['date_created'] ?? "",
      arrival_time: parsedJson['arrival_time'] ?? "",
        status: parsedJson['status'] ?? "",
      departure_time: parsedJson['departure_time'] ?? "",
        attr: parsedJson['attr'],
      registration_type: parsedJson['registration_type'] ?? "",
      resident_id: parsedJson['resident_id'] ?? "",
      unit_id: parsedJson['unit_id'] ?? "",
      security_id: parsedJson['security_id'] ?? "",
      resident: parsedJson['resident'] ?? "",
      security: parsedJson['security'] ?? "",
        );
  }
//
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date_arrival": date_arrival,
      "vehicle_number": vehicle_number ?? "",
      "date_created":date_created ?? "",
      "arrival_time": arrival_time ?? "",
      "status": status ?? 0,
      "departure_time": departure_time ?? 0,
      "attr": attr,
      "registration_type": registration_type ?? false,
      "unit_id": unit_id ?? false,
      "resident_id": resident_id ?? 0,
      "security_id": security_id ?? 0,
      "resident": resident ?? 0,
      "security": security ?? 0,
    };
  }

}
