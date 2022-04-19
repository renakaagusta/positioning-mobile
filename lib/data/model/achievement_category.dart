class AchievementCategory {
  String? id;
  String? instance;
  String? title;

  AchievementCategory(
      {this.id, this.instance,
      this.title,});

  AchievementCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    instance = json['instance'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['instance'] = this.instance;
    data['title'] = this.title;
    return data;
  }
}