import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> studentData;
  const EditProfileScreen({super.key, required this.studentData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  static const Color bgColor = Color(0xFF0B0F14);
  static const Color cardColor = Color(0xFF151A22);
  static const Color primaryColor = Color(0xFFD9FF3F);

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _classController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _dietController;
  late TextEditingController _allergiesController;
  late TextEditingController _parentController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.studentData["name"] ?? "");
    _ageController =
        TextEditingController(text: widget.studentData["age"]?.toString() ?? "");
    _classController =
        TextEditingController(text: widget.studentData["class"] ?? "");
    _heightController =
        TextEditingController(text: widget.studentData["height"]?.toString() ?? "");
    _weightController =
        TextEditingController(text: widget.studentData["weight"]?.toString() ?? "");
    _dietController =
        TextEditingController(text: widget.studentData["dietPreference"] ?? "");
    _allergiesController =
        TextEditingController(text: widget.studentData["allergies"] ?? "");
    _parentController =
        TextEditingController(text: widget.studentData["parentContact"] ?? "");
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedData = {
        "name": _nameController.text.trim(),
        "age": int.tryParse(_ageController.text.trim()),
        "class": _classController.text.trim(),
        "height": int.tryParse(_heightController.text.trim()),
        "weight": int.tryParse(_weightController.text.trim()),
        "dietPreference": _dietController.text.trim(),
        "allergies": _allergiesController.text.trim(),
        "parentContact": _parentController.text.trim(),
        "email": widget.studentData["email"],
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🎉 Profile updated")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
          "Edit Profile",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField("Name", _nameController, Icons.person),
              _buildField("Age", _ageController, Icons.cake,
                  keyboard: TextInputType.number),
              _buildField("Class", _classController, Icons.school),
              _buildField("Height (cm)", _heightController, Icons.height,
                  keyboard: TextInputType.number),
              _buildField("Weight (kg)", _weightController,
                  Icons.monitor_weight,
                  keyboard: TextInputType.number),
              _buildField("Diet Preference", _dietController, Icons.restaurant),
              _buildField("Allergies", _allergiesController, Icons.warning),
              _buildField("Parent Contact", _parentController, Icons.phone,
                  keyboard: TextInputType.phone),

              const SizedBox(height: 30),

              // 🔥 SAVE BUTTON
              // 🔥 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "Save Profile",
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
      ),
    );
  }

  // 🔥 MODERN INPUT FIELD
  Widget _buildField(
      String label, TextEditingController controller, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          icon: Icon(icon, color: primaryColor, size: 20),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}