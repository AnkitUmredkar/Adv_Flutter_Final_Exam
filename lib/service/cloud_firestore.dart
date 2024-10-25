import 'package:adv_flutter_final_exam/model/habit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'google_auth_servide.dart';

class CloudFireStoreService {
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
      CloudFireStoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> insertDataIntoFireStore(List<HabitModel> data) async {
    String? email = GoogleAuthService.googleAuthService.getCurrentUser()!.email;
    for (int i = 0; i < data.length; i++) {
      HabitModel noteModel = data[i];
      await fireStore
          .collection("users")
          .doc(email)
          .collection("habits")
          .doc(data[i].id.toString())
          .set(HabitModel.fromObject(noteModel));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllData() {
    String? email = GoogleAuthService.googleAuthService.getCurrentUser()!.email;
    return fireStore.collection("users").doc(email).collection("habits").snapshots();
  }
}
