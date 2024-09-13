// lib/views/notification_history_screen.dart
import 'package:flutter/material.dart';

class NotificationHistoryScreen extends StatefulWidget {
  final List<String> notificationHistory;

  NotificationHistoryScreen({required this.notificationHistory});

  @override
  _NotificationHistoryScreenState createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  void _clearNotificationHistory() {
    setState(() {
      widget.notificationHistory.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification history cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _clearNotificationHistory,
              child: Text('Clear Notifications'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.notificationHistory.length,
                itemBuilder: (context, index) {
                  int reverseIndex = widget.notificationHistory.length - 1 - index;
                  return ListTile(
                  title: Text(widget.notificationHistory[reverseIndex]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
