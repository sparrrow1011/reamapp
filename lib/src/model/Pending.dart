import 'dart:convert';

class Pending{
  String? id;
  String? narration = "0";
  String? amount = "";
  String? date_trx = "";
  String? resident_name = "";
  String? site_id = "";
  String? resident_id = "";
  int? pay_mode = 0;
  Map? attr = {};

  Pending(this.id, this.amount,
      { this.narration,  this.resident_name,  this.date_trx,
      this.site_id, this.resident_id, this.pay_mode, this.attr});

  factory Pending.fromJson(Map<String, dynamic>? parsedJson) {
    return Pending(parsedJson!['id'], parsedJson['amount'],
      narration: parsedJson['narration'] ?? "",
      resident_name: parsedJson['resident_name'] ?? "",
      date_trx: parsedJson['date_trx'] ?? "",
      site_id: parsedJson['site_id'] ?? "",
      resident_id: parsedJson['resident_id'] ?? "",
      pay_mode: parsedJson['pay_mode'] ?? 0,
      attr: parsedJson['attr'] ?? {},
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
