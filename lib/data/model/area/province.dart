class Province {
  String? id;
  String? title;

  Province({this.id, this.title});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}