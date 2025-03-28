import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripmate/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _bookingConfirmations = true;
  bool _tripReminders = true;
  bool _specialOffers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: const Color(0xFF4A6FA5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A6FA5), Color(0xFF2C3E50)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Booking Confirmations', 
                        style: TextStyle(color: Colors.white)),
                      value: _bookingConfirmations,
                      onChanged: (value) {
                        setState(() => _bookingConfirmations = value);
                        // TODO: Save preference to Firestore
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Trip Reminders',
                        style: TextStyle(color: Colors.white)),
                      value: _tripReminders,
                      onChanged: (value) {
                        setState(() => _tripReminders = value);
                        // TODO: Save preference to Firestore
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Special Offers',
                        style: TextStyle(color: Colors.white)),
                      value: _specialOffers,
                      onChanged: (value) {
                        setState(() => _specialOffers = value);
                        // TODO: Save preference to Firestore
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final token = await NotificationService.getDeviceToken();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Device token: $token')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5),
                ),
                child: const Text('View Device Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}