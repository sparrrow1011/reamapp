import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Dues{
  String? amount = "";
  String? due = "";
  String? due_id = "";
   final TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;
  String control = "";

  Dues(this.due, this.due_id, this.amount,);

  factory Dues.fromJson(Map<String, dynamic>? parsedJson) {
    return Dues(parsedJson!['die'], parsedJson['due_id'], parsedJson['amount']);
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
