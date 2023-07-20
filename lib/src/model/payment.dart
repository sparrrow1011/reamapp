import 'dart:convert';

class Payment{
  String? id;
  String? balance = "0";
  String? amount = "";
  String? document_id = "";
  String? date_trx = "";
  String? invoice_number = "";
  String? resident_id = "";
  int? type = 0;

  Payment(this.id, this.balance,
      { this.amount,  this.document_id,  this.date_trx,
      this.invoice_number, this.resident_id, this.type});

  factory Payment.fromJson(Map<String, dynamic>? parsedJson) {
    return Payment(parsedJson!['id'], parsedJson['balance'],
      amount: parsedJson['amount'] ?? "",
      document_id: parsedJson['document_id'] ?? "",
      date_trx: parsedJson['date_trx'] ?? "",
      invoice_number: parsedJson['invoice_number'] ?? "",
      resident_id: parsedJson['resident_id'] ?? "",
      type: parsedJson['type'] ?? 0,
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
