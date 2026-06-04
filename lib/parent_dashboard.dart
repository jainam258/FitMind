import 'package:flutter/material.dart';
import 'data_store.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'meal_plan_screen.dart';
import 'trackers_screen.dart';

/// ------------------ PARENT DASHBOARD ------------------
class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    TrackersScreen(),
    ParentDashboardHome(),
    NotificationsScreen(),
    MealPlanScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFB388FF); // Lavender accent for Parent
    const Color inactiveColor = Color(0xFF8B949E);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1319),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.track_changes_outlined, "Trackers", activeColor, inactiveColor),
                _buildNavItem(1, Icons.home_outlined, "Home", activeColor, inactiveColor),
                _buildNavItem(2, Icons.notifications_outlined, "Alerts", activeColor, inactiveColor),
                _buildNavItem(3, Icons.restaurant_menu_outlined, "Meal Plan", activeColor, inactiveColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor, Color inactiveColor) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------- PARENT DASHBOARD HOME ----------------
class ParentDashboardHome extends StatelessWidget {
  const ParentDashboardHome({super.key});

  static const Color bgColor = Color(0xFF0B0F14);
  static const Color cardColor = Color(0xFF151A22);
  static const Color primaryColor = Color(0xFFB388FF); // Lavender accent
  static const Color accentBg = Color(0x12B388FF);
  static const Color textPrimary = Colors.white;
  static const Color textMuted = Color(0xFF8B949E);

  final Map<String, String> mealTimes = const {
    "Breakfast": "7:00 AM",
    "Morning Snack": "10:00 AM",
    "Lunch": "1:00 PM",
    "Evening Snack": "4:00 PM",
    "Dinner": "7:00 PM",
  };

  String getNutritionInfo(String meal) {
    switch (meal) {
      case "Oatmeal":
        return "🥣 150 kcal | 5g Protein | 27g Carbs | 3g Fat";
      case "Fruit Salad":
        return "🍎 80 kcal | 1g Protein | 20g Carbs | 0g Fat";
      case "Grilled Chicken":
        return "🍗 220 kcal | 30g Protein | 0g Carbs | 5g Fat";
      case "Paneer Sandwich":
        return "🥪 250 kcal | 12g Protein | 30g Carbs | 10g Fat";
      case "Veggie Soup":
        return "🥣 90 kcal | 2g Protein | 15g Carbs | 2g Fat";
      default:
        return "🍽️ 200 kcal | 10g Protein | 25g Carbs | 5g Fat";
    }
  }

  Color getMealColor(String mealType) {
    switch (mealType) {
      case "Breakfast":
        return Colors.orangeAccent;
      case "Morning Snack":
        return Colors.tealAccent;
      case "Lunch":
        return Colors.blueAccent;
      case "Evening Snack":
        return Colors.pinkAccent;
      case "Dinner":
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${now.day} ${months[now.month - 1]} ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage("assets/images/logo3.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(
                "assets/images/logo3.png",
                errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, color: primaryColor),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Fit Mind Parent",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: textMuted),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8A5FF6), Color(0xFFB388FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A5FF6).withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.face_retouching_natural, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "Hello Parent! 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ValueListenableBuilder<int>(
                    valueListenable: DataStore.streakCount,
                    builder: (context, streak, _) {
                      double progress = (streak % 7) / 7;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Your Child's Streak Progress",
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                              Text(
                                "${(progress * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Features Grid without borders
            Row(
              children: [
                Expanded(
                  child: _featureCard(
                    context,
                    Icons.local_fire_department,
                    "Child's Streaks",
                    Colors.orangeAccent,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ParentStreaksScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _featureCard(
                    context,
                    Icons.calendar_today_outlined,
                    "Today's Date\n${_getTodayDate()}",
                    Colors.tealAccent,
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Today is ${_getTodayDate()}")),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's meals section
            const Text(
              "Your Child's Meals 🍽️",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 12),
            
            ValueListenableBuilder<Map<String, List<String>>>(
              valueListenable: DataStore.todaysMeals,
              builder: (context, mealsByType, _) {
                bool hasMeals = mealsByType.values.any((list) => list.isNotEmpty);

                if (!hasMeals) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "No meals logged today by your child. 🍌🥗",
                      style: TextStyle(color: textMuted, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Column(
                  children: mealsByType.entries.map((entry) {
                    final mealType = entry.key;
                    final meals = entry.value;
                    if (meals.isEmpty) return const SizedBox.shrink();

                    final headerColor = getMealColor(mealType);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 6),
                          child: Text(
                            "★ $mealType",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: headerColor,
                            ),
                          ),
                        ),
                        ...meals.map((meal) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: headerColor.withOpacity(0.12),
                                  child: Icon(Icons.restaurant, color: headerColor, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        getNutritionInfo(meal),
                                        style: const TextStyle(color: textMuted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                // Borderless Remove button
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  tooltip: "Remove this meal",
                                  onPressed: () {
                                    final updated = Map<String, List<String>>.from(mealsByType);
                                    updated[mealType] = List<String>.from(updated[mealType]!);
                                    updated[mealType]!.remove(meal);
                                    DataStore.todaysMeals.value = updated;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("$meal removed")),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ CHILD'S STREAKS SCREEN ------------------
class ParentStreaksScreen extends StatefulWidget {
  const ParentStreaksScreen({super.key});

  @override
  State<ParentStreaksScreen> createState() => _ParentStreaksScreenState();
}

class _ParentStreaksScreenState extends State<ParentStreaksScreen> {
  static const Color bgColor = Color(0xFF0B0F14);
  static const Color cardColor = Color(0xFF151A22);
  static const Color primaryColor = Color(0xFFB388FF); // Lavender accent
  static const Color textMuted = Color(0xFF8B949E);

  final List<int> milestones = const [50, 100, 200, 365];
  late List<Map<String, dynamic>> streakDays;

  @override
  void initState() {
    super.initState();
    _updateStreakDays();
  }

  void _updateStreakDays() {
    final now = DateTime.now();
    final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final todayIndex = now.weekday - 1;

    streakDays = List.generate(7, (index) {
      bool done = false;
      if (DataStore.streakCount.value > 0 && index <= todayIndex) {
        done = true;
      }
      return {"day": weekDays[index], "done": done};
    });
  }

  List<int> _getAchievedRewards(int streak) {
    return milestones.where((milestone) => streak >= milestone).toList();
  }

  int _nextMilestone(int streak) {
    return milestones.firstWhere((m) => m > streak, orElse: () => -1);
  }

  @override
  Widget build(BuildContext context) {
    _updateStreakDays();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Child's Streaks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<int>(
          valueListenable: DataStore.streakCount,
          builder: (context, streak, _) {
            final achievedRewards = _getAchievedRewards(streak);
            final next = _nextMilestone(streak);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Streak Hero Banner without borders
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF8A5FF6), Color(0xFFB388FF)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A5FF6).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 44, color: Colors.orange),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Streak: $streak Days",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              next != -1
                                  ? Text("Next milestone reward at $next meals 🎯",
                                      style: const TextStyle(color: Colors.white70, fontSize: 12))
                                  : const Text("🎉 All milestones achieved!",
                                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Weekly Active Days", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),

                  // Weekly streak grid without borders
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: streakDays.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final day = streakDays[index];
                      final isDone = day["done"] as bool;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                          color: isDone ? const Color(0x228A5FF6) : cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isDone ? primaryColor : textMuted,
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                day["day"] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDone ? Colors.white : textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Weekly Progress bar
                  const Text("Weekly Progress", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Completion Rate", style: TextStyle(color: textMuted, fontSize: 12)),
                            Text(
                              "${(streakDays.where((d) => d["done"] as bool).length / streakDays.length * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: streakDays.where((d) => d["done"] as bool).length / streakDays.length,
                            minHeight: 8,
                            backgroundColor: Colors.white10,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rewards earned
                  const Text("Rewards Earned 🎁", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  achievedRewards.isEmpty
                      ? const Text("No milestone rewards achieved yet.", style: TextStyle(color: textMuted, fontSize: 13))
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: achievedRewards.map((days) {
                            return Chip(
                              label: Text("$days-Day Streak"),
                              avatar: const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                              backgroundColor: const Color(0x1A8A5FF6),
                              labelStyle: const TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                              side: BorderSide.none,
                            );
                          }).toList(),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
