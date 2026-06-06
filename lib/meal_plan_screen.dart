import 'package:flutter/material.dart';
import 'data_store.dart';

class MealPlan {
  final String name;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;

  MealPlan({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color primaryColor = Color(0xFFD9FF3F);
  static const Color textMuted = Color(0xFF8B949E);

  final Map<String, List<MealPlan>> mealsByType = {
    "Breakfast": [
      MealPlan(name: "Oats", calories: "250", protein: "10", carbs: "40", fat: "5"),
      MealPlan(name: "Eggs", calories: "150", protein: "12", carbs: "1", fat: "10"),
      MealPlan(name: "Toast", calories: "200", protein: "6", carbs: "30", fat: "5"),
      MealPlan(name: "Smoothie", calories: "180", protein: "5", carbs: "35", fat: "2"),
      MealPlan(name: "Upma", calories: "300", protein: "8", carbs: "50", fat: "6"),
    ],
    "Morning Snack": [
      MealPlan(name: "Fruit Bowl", calories: "150", protein: "2", carbs: "35", fat: "1"),
      MealPlan(name: "Nuts", calories: "200", protein: "6", carbs: "10", fat: "15"),
    ],
    "Lunch": [
      MealPlan(name: "Rice & Dal", calories: "400", protein: "15", carbs: "70", fat: "8"),
      MealPlan(name: "Paneer Roti", calories: "450", protein: "20", carbs: "50", fat: "15"),
    ],
    "Evening Snack": [
      MealPlan(name: "Sandwich", calories: "250", protein: "8", carbs: "30", fat: "10"),
      MealPlan(name: "Biscuits", calories: "150", protein: "3", carbs: "25", fat: "5"),
      MealPlan(name: "Tea", calories: "100", protein: "2", carbs: "10", fat: "4"),
      MealPlan(name: "Poha", calories: "200", protein: "5", carbs: "35", fat: "6"),
      MealPlan(name: "Corn", calories: "180", protein: "4", carbs: "30", fat: "3"),
    ],
    "Dinner": [
      MealPlan(name: "Chapati Sabji", calories: "350", protein: "10", carbs: "50", fat: "10"),
      MealPlan(name: "Khichdi", calories: "300", protein: "12", carbs: "45", fat: "8"),
      MealPlan(name: "Soup", calories: "200", protein: "6", carbs: "20", fat: "5"),
      MealPlan(name: "Paneer Bowl", calories: "400", protein: "18", carbs: "20", fat: "20"),
      MealPlan(name: "Salad", calories: "150", protein: "5", carbs: "15", fat: "5"),
    ],
  };

  final List<String> tabs = [
    "Breakfast",
    "Morning Snack",
    "Lunch",
    "Evening Snack",
    "Dinner"
  ];

  void _addMeal(String type, MealPlan meal) {
    DataStore.addMeal(type, meal.name);
    DataStore.incrementStreak();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: primaryColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Added ${meal.name} to $type!",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Styled Meal Card (borderless, with tags) ───────────────────
  Widget mealCard(String type, MealPlan meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.restaurant, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                const SizedBox(height: 8),
                // Nutrition tags Row
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildNutritionTag("${meal.calories} kcal", const Color(0xFFFFA726)),
                    _buildNutritionTag("${meal.protein}g Pro", const Color(0xFF66BB6A)),
                    _buildNutritionTag("${meal.carbs}g Carb", const Color(0xFF29B6F6)),
                  ],
                )
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.add_circle, color: primaryColor, size: 30),
            onPressed: () => _addMeal(type, meal),
            splashRadius: 24,
          )
        ],
      ),
    );
  }

  Widget _buildNutritionTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: bgColor,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Meal Planner",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              height: 38,
              margin: const EdgeInsets.only(bottom: 10),
              child: TabBar(
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                ),
                labelColor: Colors.black,
                unselectedLabelColor: textMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                tabs: tabs.map((e) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(e),
                  ),
                )).toList(),
              ),
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ValueListenableBuilder<int>(
                valueListenable: DataStore.streakCount,
                builder: (_, value, __) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1C08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "🔥 $value",
                        style: const TextStyle(color: Color(0xFFFFA726), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),

        body: TabBarView(
          children: tabs.map((type) {
            final meals = mealsByType[type] ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: meals.length,
              itemBuilder: (_, i) => mealCard(type, meals[i]),
            );
          }).toList(),
        ),
      ),
    );
  }
}