import 'dart:convert';

class Resident{
  String? id;
  String? name;
  String? first_name;
  String? last_name = "";
  String? email = "";
  String? phone = "";
  String? unit_type = "";
  int? type = 1;
  String? unit_id = "";
  String? unit = "";
  String? unit_name = "";
  String? street_name = "";
  int? status = 1;
  String? date_start = "";
  String? date_exit = "";
  String? residency_id = "";
  String? primary_id = "";
  String? site_id = "";
  int? active_status = 1;
  bool? in_debt = false;
  Map? attr = {};

  Resident(this.id, this.email,
      { this.last_name,  this.first_name,  this.name,
      this.phone, this.status, this.unit_type, this.attr, this.type,
      this.unit_id, this.unit, this.unit_name, this.street_name,
        this.date_start, this.date_exit, this.residency_id, this.primary_id, this.site_id, this.active_status, this.in_debt});

  factory Resident.fromJson(Map<String, dynamic>? parsedJson) {
    return Resident(parsedJson!['id'], parsedJson['email'],
      last_name: parsedJson['last_name'] ?? "",
      first_name: parsedJson['first_name'] ?? "",
      name: parsedJson['name'] ?? "",
      phone: parsedJson['phone'] ?? "",
        status: parsedJson['status'] ?? 0,
      unit_type: parsedJson['unit_type'] ?? "",
        attr: parsedJson['attr'],
      type: parsedJson['type'] ?? 1,
      unit_id: parsedJson['unit_id'] ?? "",
      unit_name: parsedJson['unit_name'] ?? "",
      unit: parsedJson['unit'] ?? "",
      street_name: parsedJson['street_name'] ?? "",
      date_start: parsedJson['date_start'] ?? "",
      date_exit: parsedJson['date_exit'] ?? "",
      residency_id: parsedJson['residency_id'] ?? "",
      primary_id: parsedJson['primary_id'] ?? "",
      site_id: parsedJson['site_id'] ?? "",
      active_status: parsedJson['active_status'] ?? 1,
      in_debt: parsedJson['in_debt'] ?? false,
        );
  }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "email": email,
//       "phone": phone,
//       "first_name": first_name ?? "",
//       "last_name":last_name ?? "",
//       "site_id": site_id ?? "",
//       "status": status ?? 0,
//       "active_status": active_status ?? 0,
//       "attr": attr,
//       "support_account": support_account ?? false,
//       "is_site_user": is_site_user ?? false,
//       "role": role ?? 0,
//       "type": type ?? 0,
//       "sub_type": sub_type ?? 0,
//     };
//   }

}
