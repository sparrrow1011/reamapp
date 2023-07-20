import 'dart:convert';

class User{
  String? id;
  String? site_id;
  int? status = 1;
  int? active_status = 1;
  String? first_name;
  String? last_name = "";
  String? email = "";
  String? phone = "";
  bool? support_account = false;
  bool? is_site_user = false;
  bool? is_resident = true;
  int? role = 0;
  int? type = 0;
  int? sub_type = 0;
  Map? attr = {};
  String? Address = "";

  User(this.email, this.phone,
      { this.last_name,  this.first_name,  this.id,
      this.site_id, this.status, this.active_status, this.attr, this.support_account,
      this.is_site_user, this.role, this.type, this.sub_type, this.is_resident, this.Address});

  factory User.fromJson(Map<String, dynamic>? parsedJson) {
    return User(parsedJson!['email'], parsedJson['phone'],
        first_name: parsedJson['first_name'] ?? "",
        id: parsedJson['id'] ?? "",
        last_name: parsedJson['last_name'] ?? "",
        site_id: parsedJson['site_id'] ?? "",
        status: parsedJson['status'] ?? "",
        active_status: parsedJson['active_status'] ?? "",
        attr: parsedJson['attr'],
        support_account: parsedJson['support_account'] ?? "",
        is_site_user: parsedJson['is_site_user'] ?? "",
        role: parsedJson['role'] ?? "",
        type: parsedJson['type'] ?? "",
        sub_type: parsedJson['sub_type'] ?? "",
      is_resident: parsedJson['is_resident'] ?? true,
      Address: parsedJson['Address'] ?? "",
        );
  }
//
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "phone": phone,
      "first_name": first_name ?? "",
      "last_name":last_name ?? "",
      "site_id": site_id ?? "",
      "status": status ?? 0,
      "active_status": active_status ?? 0,
      "attr": attr,
      "support_account": support_account ?? false,
      "is_site_user": is_site_user ?? false,
      "role": role ?? 0,
      "type": type ?? 0,
      "sub_type": sub_type ?? 0,
      "is_resident": is_resident,
      "Address": Address
    };
  }

}
