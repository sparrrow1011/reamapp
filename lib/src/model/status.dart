import 'dart:convert';

class Status{
  String? id;
  String? balance = "0";
  String? first_name;
  String? invoices = "";
  String? last_name = "";
  String? payments = "";
  String? title = "";
  String? due = "";
  String? due_id = "";
  String? name = "";
  String? site_id = "";
  String? unit_id = "";
  int? unit_type = 1;
  Map? attr = {};

  Status(this.id, this.balance,
      { this.first_name,  this.invoices,  this.last_name,
      this.payments, this.title, this.due, this.due_id,this.name, this.attr, this.site_id, this.unit_id, this.unit_type});

  factory Status.fromJson(Map<String, dynamic>? parsedJson) {
    return Status(parsedJson!['id'], parsedJson['balance'],
      first_name: parsedJson['first_name'] ?? "",
      invoices: parsedJson['invoices'] ?? "",
      last_name: parsedJson['last_name'] ?? "",
      payments: parsedJson['payments'] ?? "",
      title: parsedJson['title'] ?? "",
      due: parsedJson['due'] ?? "",
        attr: parsedJson['attr'],
      due_id: parsedJson['due_id'] ?? "",
      name: parsedJson['name'] ?? "",
      unit_id: parsedJson['unit_id'] ?? "",
      site_id: parsedJson['site_id'] ?? "",
      unit_type: parsedJson['unit_type'] ?? 0,

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
