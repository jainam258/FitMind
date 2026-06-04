import 'package:flutter/material.dart';

/// ------------------ DATA STORE ------------------
class DataStore {
  /// ------------------ MEALS ------------------
  // Stores today's meals by type
  static final ValueNotifier<Map<String, List<String>>> todaysMeals =
  ValueNotifier({
    "Breakfast": [],
    "Snack 1": [],
    "Lunch": [],
    "Snack 2": [],
    "Dinner": [],
  });

  /// Stores the full meal plan for all days
  static final ValueNotifier<Map<String, Map<String, List<String>>>>
  mealPlans = ValueNotifier({});

  /// Add meal for today or specific day
  static void addMeal(String mealType, String meal, {String? day}) {
    final targetDay = day ?? "today";

    // Add to today's meals if applicable
    if (targetDay == "today") {
      if (meal.isNotEmpty) {
        final updated = Map<String, List<String>>.from(todaysMeals.value);
        updated[mealType] = [...(updated[mealType] ?? []), meal];
        todaysMeals.value = updated;
      }
    }

    // Add to meal plan
    final currentPlan = Map<String, Map<String, List<String>>>.from(mealPlans.value);
    currentPlan[targetDay] ??= {
      "Breakfast": [],
      "Snack 1": [],
      "Lunch": [],
      "Snack 2": [],
      "Dinner": [],
    };

    currentPlan[targetDay]![mealType] = [
      ...currentPlan[targetDay]![mealType]!,
      meal
    ];

    mealPlans.value = currentPlan;

    // Push notification
    addNotification("🍴 Added $meal to $mealType ($targetDay)");
  }

  static void clearMeals() {
    todaysMeals.value = {
      "Breakfast": [],
      "Snack 1": [],
      "Lunch": [],
      "Snack 2": [],
      "Dinner": [],
    };
  }

  /// ------------------ EXERCISES ------------------
  static List<Map<String, dynamic>> exercises = [
    {"title": "10 min Yoga", "icon": "🧘", "color": 0xFF81C784},
    {"title": "20 Pushups", "icon": "💪", "color": 0xFF64B5F6},
    {"title": "15 min Running", "icon": "🏃", "color": 0xFFFFB74D},
  ];

  static void addExercise(String title, String icon, int color) {
    exercises.add({"title": title, "icon": icon, "color": color});
    addNotification("💪 New exercise added: $title");
  }

  /// ------------------ BADGES ------------------
  static List<Map<String, dynamic>> badges = [
    {"title": "Healthy Eater", "icon": "🥗"},
    {"title": "7-Day Streak", "icon": "🔥"},
    {"title": "Fitness Starter", "icon": "🏅"},
  ];

  static void addBadge(String title, String icon) {
    badges.add({"title": title, "icon": icon});
    addNotification("🏆 You earned a new badge: $title");
  }

  /// ------------------ STREAKS ------------------
  static final ValueNotifier<int> streakCount = ValueNotifier<int>(0);
  static DateTime? lastLogin; // track last login date

  static void incrementStreak() {
    streakCount.value++;
    addNotification("🔥 You continued your streak! (${streakCount.value} days)");
  }

  static void resetStreak() {
    streakCount.value = 0;
    addNotification("❌ Streak reset");
  }

  static void handleLogin() {
    final today = DateTime.now();

    if (lastLogin == null || today.difference(lastLogin!).inDays > 1) {
      resetStreak(); // missed a day
    }

    incrementStreak(); // add 1 for today
    lastLogin = today;
  }

  /// ------------------ NOTIFICATIONS ------------------
  static final ValueNotifier<List<String>> notifications =
  ValueNotifier<List<String>>([
    "🎉 Welcome to FitMind!",
  ]);

  static void addNotification(String message) {
    final updated = List<String>.from(notifications.value);
    updated.insert(0, message); // latest on top
    notifications.value = updated;
  }
}

/// ------------------ QNA ------------------
class QnAStore {
  static final List<int> answers = [];

  static void addAnswer(int score) {
    answers.add(score);
  }

  static void clear() {
    answers.clear();
  }
}
