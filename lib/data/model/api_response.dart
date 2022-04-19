class ApiResponse {
  String? status;
  String? message;
  dynamic? data;
  String? error;

  ApiResponse({this.status, this.message, this.data, this.error});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message;
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}
