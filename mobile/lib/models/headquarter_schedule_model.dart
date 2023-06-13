class HeadquarterScheduleModel {
  int day;
  DateTime startAt;
  DateTime endAt;

  HeadquarterScheduleModel({
    required this.day,
    required this.startAt,
    required this.endAt,
  });

  HeadquarterScheduleModel.fromMap(Map<String, dynamic> map)
      : day = map['day'],
        startAt = map['schedules']['start'],
        endAt = map['schedules']['end'];

  static List<HeadquarterScheduleModel> fromMapList(List<dynamic> list) {
    return list.map((item) => HeadquarterScheduleModel.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'schedules': {
        'start': startAt.toIso8601String(),
        'end': endAt.toIso8601String(),
      }
    };
  }
}
