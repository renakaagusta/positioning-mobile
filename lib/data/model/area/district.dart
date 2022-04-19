class District {
  String? id;
  String? regency;
  String? title;

  District({this.id, this.regency, this.title});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    regency = json['regency'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['regency'] = this.regency;
    data['title'] = this.title;
    return data;
  }
}