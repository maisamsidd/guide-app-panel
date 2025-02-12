class UserModel {
  String? email;
  String? name;
  String? lastName;
  String? contactNumber;
  String? userId;

  UserModel(
      {this.email, this.name, this.lastName, this.contactNumber, this.userId});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    lastName = json['last_name'];
    contactNumber = json['contact_number'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['contact_number'] = this.contactNumber;
    data['userId'] = this.userId;
    return data;
  }
}
