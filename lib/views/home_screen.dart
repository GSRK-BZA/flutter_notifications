import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_history_screen.dart';
import '../controllers/notification_controller.dart';
import 'registration_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class TruthsProvider {
  // Function to get the user's email
  String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? 'User'; // Return email if available, else 'User'
  }

  // List of truths incorporating the user's email
  List<String> getTruths() {
    String email = getUserEmail(); // Get the user's email
    return [
      "Did you know that $email has a great sense of humor?",
      "$email is one of a kind!",
      "Studies show that $email is awesome at multitasking.",
      "$email never gives up!",
      "In a world of change, $email remains constant.",
      "People who know $email are lucky indeed.",
      "$email has a sharp mind and a kind heart.",
      "There's no one quite like $email in the entire world.",
      "The future is bright for $email!",
      "$email is destined for great things."
    ];
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationController _notificationController = NotificationController();

  List<String> notificationTypes = ['Truth','News','Jokes'];
  List<String> selectedNotificationTypes = [];
  late TruthsProvider truthsProvider;
  List<String> truths = [];
  List<String> news = [
    'Global temperatures hit new record highs.',
    'Stock market reaches an all-time high today.',
    'A breakthrough in cancer research has been announced.',
    'New tech startup raises \$100 million in funding.',
    'Scientists discover a new species in the Amazon.',
    'SpaceX successfully launches another rocket to Mars.',
    'A major hurricane is approaching the east coast.',
    'The inflation rate has dropped to a 5-year low.',
    'Olympics will be held next year in Paris.',
    'Electric vehicle sales surged by 40% this year.'
  ];
  List<String> jokes = [
    'Why don\'t skeletons fight each other? They don\'t have the guts.',
    'I told my wife she was drawing her eyebrows too high. She looked surprised.',
    'Why don\'t some couples go to the gym? Because some relationships don\'t work out.',
    'Why do cows have hooves instead of feet? Because they lactose.',
    'I asked my dog what\'s two minus two. He said nothing.',
    'What did the grape do when it got stepped on? Nothing, but it let out a little wine.',
    'Why don\'t eggs tell jokes? They\'d crack each other up.',
    'Why couldn\'t the bicycle stand up by itself? It was two-tired.',
    'What did the janitor say when he jumped out of the closet? Supplies!',
    'Why are elevator jokes so classic and good? They work on so many levels.'
  ];

  late Map<String, List<String>> mockNotifications;

  @override
  void initState() {
    super.initState();
     // Initialize the TruthsProvider and populate the truths list
    truthsProvider = TruthsProvider();
    truths = truthsProvider.getTruths();
    
    // Debugging: Print truths to verify they're loaded
    // Assign the notifications, including truths, news, and jokes
    mockNotifications = {
      'Truth': truths,
      'News': news,
      'Jokes': jokes,
    };
    
  }
  String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? 'User'; // Return email if available, else 'User'
  }
  
  int intervalInSeconds = 5;
  Timer? _timer;

  void _selectNotificationTypes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Notification Types'),
          content: StatefulBuilder( // Use StatefulBuilder to manage state inside the dialog
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: mockNotifications.keys.map((type) {
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
              );
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

  String getRandomNotification(String category) {
    final random = Random();
    
    if (category == 'Truth') {
      return truths[random.nextInt(truths.length)];
    } else if (category == 'News') {
      return news[random.nextInt(news.length)];
    } else if (category == 'Jokes') {
      return jokes[random.nextInt(jokes.length)];
    } else {
      return 'Unknown category';
    }
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

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: intervalInSeconds), (timer) {
      _sendNotifications();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications started!')),
    );
  }

 void _sendNotifications() {
  if (selectedNotificationTypes.isNotEmpty) {
    // Randomly select one type from the selectedNotificationTypes
    String randomType = selectedNotificationTypes[Random().nextInt(selectedNotificationTypes.length)];
    
    // Get the notifications for that random type
    List<String> notifications = mockNotifications[randomType] ?? [];
    
    // If there are notifications for the selected type, show one randomly
    if (notifications.isNotEmpty) {
      String notification = getRandomNotification(randomType);
      _notificationController.showNotification(notification);
    }
  }
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
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20.0), // Adds a 20px margin around the text
                child: Text(
                'Hello, ${getUserEmail()}!',
                style: TextStyle(
                  fontSize: 24.0,  // Font size
                  fontWeight: FontWeight.bold,  // Bold text
                  color: Colors.black,  // Text color
                  letterSpacing: 1.2,  // Space between letters
                  height: 1.5,  // Line height
                  fontFamily: 'Roboto',  // Font family (make sure to include it in pubspec.yaml if custom)
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,  // Shadow blur radius
                      color: Colors.grey.withOpacity(0.5),  // Shadow color with opacity
                      offset: Offset(2.0, 2.0),  // Shadow offset
                    ),
                  ],
                ),
              ),

              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 243, 33, 198), padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),  // Text color
                  shape: RoundedRectangleBorder(  // Rounded corners
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5.0,  // Add shadow effect
                ),
                child: Text('Select Notification Types',
                  style: TextStyle(
                    fontSize: 18.0,  // Font size
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                ),
                onPressed: _selectNotificationTypes,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 62, 201, 7), padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),  // Text color
                  shape: RoundedRectangleBorder(  // Rounded corners
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5.0,  // Add shadow effect
                ),
                child: Text('Select Notification Frequency (seconds)',
                  style: TextStyle(
                    fontSize: 18.0,  // Font size
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                ),
                onPressed: _selectFrequency,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),  // Text color
                  shape: RoundedRectangleBorder(  // Rounded corners
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5.0,  // Add shadow effect
                ),
                child: Text(
                  'Start Sending Notifications',
                  style: TextStyle(
                    fontSize: 18.0,  // Font size
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                ),
                onPressed: _startNotifications,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 180, 33, 243), padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),  // Text color
                  shape: RoundedRectangleBorder(  // Rounded corners
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5.0,  // Add shadow effect
                ),
                child: Text('Show Notification History',
                  style: TextStyle(
                    fontSize: 18.0,  // Font size
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationHistoryScreen(
                        notificationHistory: _notificationController.notificationHistory,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 255, 153, 0), padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),  // Text color
                  shape: RoundedRectangleBorder(  // Rounded corners
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5.0,  // Add shadow effect
                ),
                child: Text('Logout',
                style: TextStyle(
                    fontSize: 18.0,  // Font size
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                ),
                onPressed: _logout,
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }
}
