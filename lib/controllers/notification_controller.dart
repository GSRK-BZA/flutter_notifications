import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';

class NotificationController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;

  List<NotificationModel> notificationHistory = [];

  void initializeNotificationPlugin() {
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final InitializationSettings initializationSettings = 
        InitializationSettings(android: initializationSettingsAndroid);
    
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startNotifications(List<String> selectedNotificationTypes, Map<String, List<String>> mockNotifications, int intervalInSeconds, Function(String) onNotificationSent) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalInSeconds), (timer) {
      _sendNotifications(selectedNotificationTypes, mockNotifications, onNotificationSent);
    });
  }

  void stopNotifications() {
    _timer?.cancel();
  }

  void _sendNotifications(List<String> selectedNotificationTypes, Map<String, List<String>> mockNotifications, Function(String) onNotificationSent) {
    for (String type in selectedNotificationTypes) {
      List<String> notifications = mockNotifications[type] ?? [];
      if (notifications.isNotEmpty) {
        String notification = notifications[DateTime.now().second % notifications.length];
        _showNotification(notification);
        onNotificationSent(notification);
      }
    }
  }

  Future<void> _showNotification(String notificationMessage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      notificationMessage,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }

  void clearNotificationHistory() {
    notificationHistory.clear();
  }
}
