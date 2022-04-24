class RouteCollection {
  String? id;
  List<Routes>? routes;
  String? type;

  RouteCollection({this.id, this.routes, this.type});

  RouteCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }
}

class Routes {
  String? from;
  List<String>? to;

  Routes({this.from, this.to});

  Routes.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}