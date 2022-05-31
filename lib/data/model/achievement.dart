class Achievement {
  String? id;
  String? instance;
  String? category;
  String? title;
  int? rank;
  int? score;
  String? status;

  Achievement(
      {this.id, this.instance,
      this.category,
      this.title,
      this.rank,
      this.score,
      this.status});

  Achievement.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    instance = json['instance'];
    category = json['category'];
    title = json['title'];
    rank = json['rank'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['instance'] = this.instance;
    data['category'] = this.category;
    data['title'] = this.title;
    data['rank'] = this.rank;
    data['score'] = this.score;
    data['status'] = this.status;
    return data;
  }
}