class HabitModel {
  late String habitName, targetDays, progress;
  late int id;

  HabitModel({
    required this.id,
    required this.habitName,
    required this.targetDays,
    required this.progress,
  });

  factory HabitModel.fromMap(Map m1) {
    return HabitModel(
        id: m1["id"],
        habitName: m1["habitName"],
        targetDays: m1["targetDays"],
        progress: m1["progress"]);
  }

  static Map<String, dynamic> fromObject(HabitModel habitModel) {
    return {
      "id": habitModel.id,
      "habitName": habitModel.habitName,
      "targetDays": habitModel.targetDays,
      "progress": habitModel.progress,
    };
  }
}
