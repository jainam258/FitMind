import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color bgColor = Color(0xFF0B0F14);
  static const Color cardColor = Color(0xFF151A22);
  static const Color primaryColor = Color(0xFFD9FF3F);

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final defaultData = {
        "name": "New User",
        "class": "N/A",
        "age": "N/A",
        "email": FirebaseAuth.instance.currentUser?.email ?? "N/A",
        "height": "N/A",
        "weight": "N/A",
        "dietPreference": "N/A",
        "allergies": "N/A",
        "parentContact": "N/A",
      };
      await docRef.set(defaultData);
      return defaultData;
    }

    return doc.data();
  }

  Future<void> _refreshProfile() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "No Profile Data",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final user = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [

                  // 🔥 PROFILE HEADER (borderless glassmorphism card)
                  Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.08),
                          ),
                          child: const CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.black26,
                            child: Icon(Icons.person_outline_rounded,
                                size: 44, color: primaryColor),
                          ),
                        ),
                        const SizedBox(height: 14),

                        Text(
                          user["name"] ?? "No Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Class ${user["class"] ?? "N/A"}  ·  Age ${user["age"] ?? "N/A"}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 INFO CARDS
                  profileTile(Icons.email_outlined, "Email", user["email"]),
                  profileTile(Icons.height_rounded, "Height", "${user["height"]} cm"),
                  profileTile(Icons.monitor_weight_outlined, "Weight", "${user["weight"]} kg"),
                  profileTile(Icons.restaurant_outlined, "Diet", user["dietPreference"]),
                  profileTile(Icons.warning_amber_outlined, "Allergies", user["allergies"]),
                  profileTile(Icons.phone_outlined, "Parent Contact", user["parentContact"]),

                  const SizedBox(height: 24),

                  // 🔥 EDIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditProfileScreen(studentData: user),
                          ),
                        );
                        if (updated == true) _refreshProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔥 MODERN TILE
  Widget profileTile(IconData icon, String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(
                  value ?? "N/A",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}