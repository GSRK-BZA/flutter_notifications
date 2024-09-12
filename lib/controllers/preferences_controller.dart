// lib/controllers/preferences_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/preferences_model.dart';

class PreferencesController {
  Future<PreferencesModel> getPreferences() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return PreferencesModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return PreferencesModel(newsNotifications: false, offersNotifications: false);
  }

  Future<void> savePreferences(PreferencesModel preferences) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(preferences.toMap());
    }
  }
}
