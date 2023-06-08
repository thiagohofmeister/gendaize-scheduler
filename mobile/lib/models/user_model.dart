class UserModel {
  String id;
  String name;
  String documentNumber;
  String email;
  String status;

  UserModel({
    required this.id,
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.status,
  });

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        documentNumber = json["documentNumber"],
        email = json["email"],
        status = json["status"];
}
