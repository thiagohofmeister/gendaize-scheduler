enum TaxType { displacement, cancellation, service }

extension TaxTypeExtension on TaxType {
  static TaxType fromString(String value) {
    Map<String, TaxType> map = {
      'DISPLACEMENT': TaxType.displacement,
      'CANCELLATION': TaxType.cancellation,
      'SERVICE': TaxType.service
    };

    return map[value]!;
  }

  getLabel() {
    Map<TaxType, String> map = {
      TaxType.displacement: 'Deslocamento',
      TaxType.cancellation: 'Cancelamento',
      TaxType.service: 'Serviço'
    };

    return map[this];
  }
}
