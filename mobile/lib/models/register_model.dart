class RegisterModel {
  RegisterOrganizationModel organization;
  RegisterUserModel user;

  RegisterModel({
    required this.organization,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'organization': organization.toMap(),
      'user': user.toMap(),
    };
  }
}

class RegisterUserModel {
  String name;
  String documentNumber;
  String email;
  String password;

  RegisterUserModel({
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.password,
  });

  RegisterUserModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        documentNumber = map['documentNumber'].replaceAll(RegExp(r'\D'), ''),
        email = map['email'],
        password = map['password'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'documentNumber': documentNumber,
      'password': password,
    };
  }
}

class RegisterOrganizationModel {
  String name;
  String email;
  String phone;
  String documentType;
  String documentNumber;
  String? documentName;

  RegisterOrganizationModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.documentType,
    required this.documentNumber,
    this.documentName,
  });

  RegisterOrganizationModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        phone = map['phone'].replaceAll(RegExp(r'\D'), ''),
        email = map['email'],
        documentName = map['document']['name'],
        documentType = map['document']['type'],
        documentNumber =
            map['document']['number'].replaceAll(RegExp(r'\D'), '');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'document': {
        'type': documentType,
        'number': documentNumber,
        'name': documentName != '' ? documentName : null,
      }
    };
  }
}
