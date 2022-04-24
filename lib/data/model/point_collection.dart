class PointCollection {
  String? id;
  String? type;
  List<Data>? data;

  PointCollection({this.id, this.type, this.data});

  PointCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Geometry? geometry;
  String? type;
  Properties? properties;

  Data({this.geometry, this.type, this.properties});

  Data.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    return data;
  }
}

class Properties {
  String? text;

  Properties({this.text});

  Properties.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}