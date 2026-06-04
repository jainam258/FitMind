import 'package:flutter/material.dart';

class MealLog extends StatelessWidget {
  const MealLog({super.key});

  final List<Map<String, String>> meals = const [
    {"time": "Breakfast", "meal": "Oatmeal with fruits"},
    {"time": "Lunch", "meal": "Vegetable salad with quinoa"},
    {"time": "Snack", "meal": "Nuts and yogurt"},
    {"time": "Dinner", "meal": "Vegetable stir fry with tofu"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vegetarian Meal Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    meals[index]['time']![0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  meals[index]['meal']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(meals[index]['time']!),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        ),
      ),
    );
  }
}
