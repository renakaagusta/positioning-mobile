class User {
  String? role;
  String? status;
  String? id;
  String? email;
  String? password;
  String? name;  
  String? username;
  dynamic? metadata;

  User(
      {this.role,
      this.status,
      this.id,
      this.email,
      this.password,
      this.name,
      this.username});

  User.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    status = json['status'];
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    username = json['username'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['status'] = this.status;
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['username'] = this.username;
    data['metadata'] = this.metadata;
    return data;
  }
}