import 'package:flutter/material.dart';

class MealPlan extends StatelessWidget {
  const MealPlan({super.key});

  final List<Map<String, String>> mealPlans = const [
    {"day": "Monday", "meal": "Oatmeal, Veg Sandwich, Nuts"},
    {"day": "Tuesday", "meal": "Vegetable Salad, Brown Rice, Fruit"},
    {"day": "Wednesday", "meal": "Paneer Stir Fry, Quinoa, Veggies"},
    {"day": "Thursday", "meal": "Pasta with Veggies, Salad, Yogurt"},
    {"day": "Friday", "meal": "Veggie Omelette, Toast, Fruit"},
    {"day": "Saturday", "meal": "Chickpea Curry, Rice, Salad"},
    {"day": "Sunday", "meal": "Vegetable Stir Fry, Brown Rice"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vegetarian Meal Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9, // increase height slightly
          ),
          itemCount: mealPlans.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView( // Fix overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mealPlans[index]['day']!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        mealPlans[index]['meal']!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text("Add to Log"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
