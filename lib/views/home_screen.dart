import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';
import 'registration_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationController _notificationController = NotificationController();

  List<String> notificationTypes = ['News', 'Updates', 'Promotions'];
  List<String> selectedNotificationTypes = [];
  Map<String, List<String>> mockNotifications = {
    'News': List.generate(10, (index) => 'News Notification $index'),
    'Updates': List.generate(10, (index) => 'Updates Notification $index'),
    'Promotions': List.generate(10, (index) => 'Promotions Notification $index'),
  };

  int intervalInSeconds = 5;

  @override
  void initState() {
    super.initState();
    _notificationController.initializeNotificationPlugin();
  }

  void _selectNotificationTypes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Notification Types'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: notificationTypes.map((type) {
              return CheckboxListTile(
                title: Text(type),
                value: selectedNotificationTypes.contains(type),
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      selectedNotificationTypes.add(type);
                    } else {
                      selectedNotificationTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            )
          ],
        );
      },
    );
  }

  void _selectFrequency() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Notification Frequency (seconds)'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter frequency in seconds'),
            onChanged: (value) {
              intervalInSeconds = int.tryParse(value) ?? 5;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _startNotifications() {
    if (selectedNotificationTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select notification types!')),
      );
      return;
    }

    _notificationController.startNotifications(selectedNotificationTypes, mockNotifications, intervalInSeconds, (notification) {
      setState(() {
        _notificationController.notificationHistory.add(NotificationModel(type: 'Notification', message: notification));
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications started!')),
    );
  }

  void _clearNotificationHistory() {
    setState(() {
      _notificationController.clearNotificationHistory();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification history cleared!')),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Select Notification Types'),
              onPressed: () => _selectNotificationTypes(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Select Notification Frequency (seconds)'),
              onPressed: () => _selectFrequency(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Start Sending Notifications'),
              onPressed: _startNotifications,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Clear Notification History'),
              onPressed: _clearNotificationHistory,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: _logout,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _notificationController.notificationHistory.length,
                itemBuilder: (context, index) {
                  final notification = _notificationController.notificationHistory[index];
                  return ListTile(
                    title: Text(notification.message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notificationController.stopNotifications();
    super.dispose();
  }
}
