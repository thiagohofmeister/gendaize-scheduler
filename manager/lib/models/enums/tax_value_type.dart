enum TaxValueType { percent, fixed, distance }

extension TaxValueTypeExtension on TaxValueType {
  static TaxValueType fromString(String value) {
    Map<String, TaxValueType> map = {
      'PERCENT': TaxValueType.percent,
      'FIXED': TaxValueType.fixed,
      'DISTANCE': TaxValueType.distance
    };

    return map[value]!;
  }

  getLabel() {
    Map<TaxValueType, String> map = {
      TaxValueType.percent: 'Porcentagem',
      TaxValueType.fixed: 'Valor fixo',
      TaxValueType.distance: 'Distância'
    };

    return map[this];
  }
}
