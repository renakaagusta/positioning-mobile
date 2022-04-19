class Regency {
  String? id;
  String? province;
  String? title;

  Regency({this.id, this.province, this.title});

  Regency.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    province = json['province'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['province'] = this.province;
    data['title'] = this.title;
    return data;
  }
}