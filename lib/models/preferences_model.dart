// lib/models/preferences_model.dart
class PreferencesModel {
  bool newsNotifications;
  bool offersNotifications;

  PreferencesModel({
    required this.newsNotifications,
    required this.offersNotifications,
  });

  Map<String, dynamic> toMap() {
    return {
      'newsNotifications': newsNotifications,
      'offersNotifications': offersNotifications,
    };
  }

  static PreferencesModel fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      newsNotifications: map['newsNotifications'] ?? false,
      offersNotifications: map['offersNotifications'] ?? false,
    );
  }
}
