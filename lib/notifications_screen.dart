import 'package:flutter/material.dart';
import 'data_store.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const Color bgColor = Color(0xFF0B0F14);
  static const Color cardColor = Color(0xFF151A22);
  static const Color primaryColor = Color(0xFFD9FF3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: ValueListenableBuilder<List<String>>(
        valueListenable: DataStore.notifications,
        builder: (context, notifications, _) {

          // ✅ EMPTY STATE
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_off,
                      size: 70, color: Colors.white30),
                  SizedBox(height: 16),
                  Text(
                    "No Notifications Yet",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // ✅ LIST
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    // 🔔 ICON
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications,
                          color: Colors.black),
                    ),

                    const SizedBox(width: 14),

                    // 📝 TEXT
                    Expanded(
                      child: Text(
                        notif,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // 🔥 OPTIONAL EMOJI BASED ON TEXT
                    Text(
                      notif.contains("streak") ? "🔥" : "🥗",
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}