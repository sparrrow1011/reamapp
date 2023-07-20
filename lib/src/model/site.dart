import 'dart:convert';

class Site{
  String? id;
  String? subdomain;
  int? status = 1;
  String? name;
  String? site_code;
  String? date_registered = "";
  bool? platform = false;
  Map? attr = {};

  Site(this.id, {this.status, this.subdomain, this.attr, this.name,this.site_code,
      this.date_registered, this.platform});

  factory Site.fromJson(Map<String, dynamic>? parsedJson) {
    return Site(parsedJson!['id'],
        subdomain: parsedJson['subdomain'] ?? "",
        name: parsedJson['name'] ?? "",
        site_code: parsedJson['site_code'] ?? "",
        date_registered: parsedJson['date_registered'] ?? "",
        status: parsedJson['status'] ?? "",
      platform: parsedJson['platform'] ?? "",
        attr: parsedJson['attr']
        );
  }
//
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subdomain": subdomain,
      "name": name ?? "",
      "site_code": site_code ?? "",
      "date_registered":date_registered ?? "",
      "platform": platform ?? "",
      "status": status ?? 0,
      "attr": attr
    };
  }

}
