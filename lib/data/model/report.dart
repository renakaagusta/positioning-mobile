class Report {
  String? id;
  String? description;
  String? rider;
  String? handler;
  List<Routes>? routes;
  String? title;
  String? status;
  DateTime? createdAt;
  String? category;
  String? endPoint;
  String? type;
  List<String>? rejectedBy;
  String? startingPoint;

  Report(
      {this.id,
      this.description,
      this.rider,
      this.handler,
      this.routes,
      this.title,
      this.status,
      this.createdAt,
      this.category,
      this.endPoint,
      this.type,
      this.startingPoint,
      this.rejectedBy});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    rider = json['rider'];
    handler = json['handler'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    title = json['title'];
    status = json['status'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']['_seconds'] * 1000);
    category = json['category'];
    endPoint = json['endPoint'];
    type = json['type'];
    startingPoint = json['startingPoint'];
    if(json["rejectedBy"] != null) {
      rejectedBy = (json["rejectedBy"] as List).map((rejectedBy)=>rejectedBy as String).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['rider'] = this.rider;
    data['handler'] = this.handler;
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['status'] = this.status;
    if (this.createdAt != null) {
      //data['createdAt'] = this.createdAt!.toJson();
    }
    data['category'] = this.category;
    data['endPoint'] = this.endPoint;
    data['type'] = this.type;
    data['startingPoint'] = this.startingPoint;
    return data;
  }
}

class Routes {
  double? lng;
  double? lat;

  Routes({this.lng, this.lat});

  Routes.fromJson(Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }
}

class CreatedAt {
  int? iSeconds;
  int? iNanoseconds;

  CreatedAt({this.iSeconds, this.iNanoseconds});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }
}