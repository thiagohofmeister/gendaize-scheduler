class UserModel {
  String name;

  UserModel({required this.name}) : super();

  UserModel.fromJson(Map<String, dynamic> json) : name = json['name'];
}
