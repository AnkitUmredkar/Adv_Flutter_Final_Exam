import 'package:adv_flutter_final_exam/model/habit_model.dart';
import 'package:adv_flutter_final_exam/service/cloud_firestore.dart';
import 'package:adv_flutter_final_exam/service/db_helper.dart';
import 'package:flutter/widgets.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> data = [], filteredData = [];
  int id = 1;
  String groupValue = "Complete";
  double per = 0.0;

  void calculateProgress() {
    double ck = 0.0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].progress == "Complete") {
        ck++;
      }
    }
    per = (ck / data.length) * 100;
    notifyListeners();
  }

  void setProgress(String value) {
    groupValue = value;
    notifyListeners();
  }

  HabitProvider() {
    DataBaseService.dataBaseService.initDb();
    getAllHabit();
    calculateProgress();
  }

  Future<void> getAllHabit() async {
    List tempData = await DataBaseService.dataBaseService.getAllData();
    data = tempData.map((e) => HabitModel.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> insertData(
      int id, String habitName, String targetDays, String progress) async {
    await DataBaseService.dataBaseService
        .insertData(id, habitName, targetDays, progress);
    getAllHabit();
  }

  Future<void> updateData(
      int id, String habitName, String targetDays, String progress) async {
    await DataBaseService.dataBaseService
        .updateData(id, habitName, targetDays, progress);
    getAllHabit();
  }

  Future<void> deleteData(int id) async {
    await DataBaseService.dataBaseService.deleteData(id);
    getAllHabit();
  }

  Future<void> syncDataCloudToDatabase() async {
    final snapShot = await CloudFireStoreService.cloudFireStoreService.getAllData().first;
    final data = snapShot.docs.map((e) {
      HabitModel habitModel = HabitModel.fromMap(e.data());
      return HabitModel(
          id: int.parse(e.id),
          habitName: habitModel.habitName,
          targetDays: habitModel.targetDays,
          progress: habitModel.progress);
    }).toList();

    for (var habit in data) {
      bool exist = await DataBaseService.dataBaseService.isExist(habit.id);
      if (exist) {
        await DataBaseService.dataBaseService.updateData(
            habit.id, habit.habitName, habit.targetDays, habit.progress);
      } else {
        await DataBaseService.dataBaseService.insertData(
            habit.id, habit.habitName, habit.targetDays, habit.progress);
      }
      await getAllHabit();
    }
  }
}
