// lib/views/preferences_screen.dart
import 'package:flutter/material.dart';
import '../controllers/preferences_controller.dart';
import '../models/preferences_model.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final PreferencesController _preferencesController = PreferencesController();
  PreferencesModel _preferences = PreferencesModel(newsNotifications: false, offersNotifications: false);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    PreferencesModel preferences = await _preferencesController.getPreferences();
    setState(() {
      _preferences = preferences;
    });
  }

  void _savePreferences() async {
    await _preferencesController.savePreferences(_preferences);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Preferences')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Receive News Notifications'),
            value: _preferences.newsNotifications,
            onChanged: (value) {
              setState(() {
                _preferences.newsNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Receive Offers Notifications'),
            value: _preferences.offersNotifications,
            onChanged: (value) {
              setState(() {
                _preferences.offersNotifications = value;
              });
            },
          ),
          ElevatedButton(
            child: Text('Save Preferences'),
            onPressed: _savePreferences,
          ),
        ],
      ),
    );
  }
}
