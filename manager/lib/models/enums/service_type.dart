enum ServiceType { external, internal }

extension ServiceTypeExtension on ServiceType {
  static ServiceType fromString(String value) {
    Map<String, ServiceType> map = {
      'EXTERNAL': ServiceType.external,
      'INTERNAL': ServiceType.internal,
    };

    return map[value]!;
  }

  getLabel() {
    Map<ServiceType, String> map = {
      ServiceType.external: 'Externo',
      ServiceType.internal: 'Interno',
    };

    return map[this];
  }
}
