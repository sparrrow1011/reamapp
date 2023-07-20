import 'dart:convert';

class Notice{
  String? id;
  Map? attr = {};
  String? date_created;
  String? date_expiry = "";
  String? message = "";
  String? site_id = "";
  String? title = "";

  Notice(this.id, this.title,
      { this.message,  this.site_id,  this.date_created, this.date_expiry, this.attr});

  factory Notice.fromJson(Map<String, dynamic>? parsedJson) {
    return Notice(parsedJson!['id'], parsedJson['title'],
      message: parsedJson['message'] ?? "",
      site_id: parsedJson['site_id'] ?? "",
      date_created: parsedJson['date_created'] ?? "",
      date_expiry: parsedJson['date_expiry'] ?? "",
        attr: parsedJson['attr'],
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
