class AuthenticationModel {
  String id;
  String token;
  String device;
  String status;

  AuthenticationModel({
    required this.id,
    required this.token,
    required this.device,
    required this.status,
  }) : super();

  AuthenticationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        token = json['token'],
        device = json['device'],
        status = json['status'];
}
