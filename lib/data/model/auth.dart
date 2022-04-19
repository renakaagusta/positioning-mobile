class Authentication {
  String? accessToken;
  String? refreshToken;
  String? userId;

  Authentication({this.accessToken, this.refreshToken, this.userId});

  Authentication.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['userId'] = this.userId;
    return data;
  }
}