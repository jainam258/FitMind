import 'package:flutter/material.dart';
import 'data_store.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'meal_plan_screen.dart';
import 'trackers_screen.dart';

// ── Design tokens (shared across all widgets in this file) ─────
const _bg        = Color(0xFF0D0D0D);
const _surface   = Color(0xFF181818);
const _cardClr   = Color(0xFF1E1E1E);
const _border    = Color(0xFF252525);
const _accent    = Color(0xFFE8F535);
const _accentBg  = Color(0xFF111F00);
const _accentBrd = Color(0xFF2A3A00);
const _white     = Colors.white;
const _muted     = Color(0xFF888888);
const _hint      = Color(0xFF555555);

// ══════════════════════════════════════════════════════════════
// StudentDashboard — shell with bottom nav (logic unchanged)
// ══════════════════════════════════════════════════════════════
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    TrackersScreen(),
    DashboardHome(),
    NotificationsScreen(),
    MealPlanScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _DarkBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ── Custom dark bottom nav ─────────────────────────────────────
class _DarkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DarkBottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    {"icon": Icons.track_changes_outlined, "label": "Trackers"},
    {"icon": Icons.home_outlined,          "label": "Home"},
    {"icon": Icons.notifications_none,     "label": "Alerts"},
    {"icon": Icons.restaurant_menu,        "label": "Meal Plan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E))),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final active = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _items[i]["icon"] as IconData,
                    color: active ? _accent : _hint,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _items[i]["label"] as String,
                    style: TextStyle(
                      color: active ? _accent : _hint,
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width:  active ? 4 : 0,
                    height: active ? 4 : 0,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// DashboardHome — main home content (logic unchanged)
// ══════════════════════════════════════════════════════════════
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  final Map<String, String> mealTimes = const {
    "Breakfast":     "7:00 AM",
    "Morning Snack": "10:00 AM",
    "Lunch":         "1:00 PM",
    "Evening Snack": "4:00 PM",
    "Dinner":        "7:00 PM",
  };

  // ── Nutrition info (logic unchanged) ──────────────────────────
  String getNutritionInfo(String meal) {
    switch (meal) {
      case "Oatmeal":
        return "150 kcal · 5g Protein · 27g Carbs · 3g Fat · 4g Fiber";
      case "Fruit Salad":
        return "80 kcal · 1g Protein · 20g Carbs · 0g Fat · Vit C";
      case "Grilled Chicken":
        return "220 kcal · 30g Protein · 0g Carbs · 5g Fat";
      case "Paneer Sandwich":
        return "250 kcal · 12g Protein · 30g Carbs · 10g Fat · Calcium";
      case "Veggie Soup":
        return "90 kcal · 2g Protein · 15g Carbs · 2g Fat · Vit A & C";
      default:
        return "";
    }
  }

  // ── Meal type accent colors (mapped to dark-friendly tones) ───
  Color getMealColor(String mealType) {
    switch (mealType) {
      case "Breakfast":     return const Color(0xFFE8A435);
      case "Morning Snack": return const Color(0xFF3BB77E);
      case "Lunch":         return const Color(0xFF378ADD);
      case "Evening Snack": return const Color(0xFFD4537E);
      case "Dinner":        return const Color(0xFF7F77DD);
      default:              return _muted;
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      // ── App bar ──────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/logo3.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.show_chart, color: _bg, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "FIT MIND",
              style: TextStyle(
                color: _white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _border),
                ),
                child: const Icon(Icons.person_outline, color: _muted, size: 20),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1E1E1E)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero greeting + progress ─────────────────────
            _buildHeroCard(),
            const SizedBox(height: 14),

            // ── Feature grid: Streaks + Date ─────────────────
            Row(
              children: [
                Expanded(child: _buildStreaksCard(context)),
                const SizedBox(width: 12),
                Expanded(child: _buildDateCard(context)),
              ],
            ),
            const SizedBox(height: 24),

            // ── Today's meals ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today's Meals",
                  style: TextStyle(
                    color: _white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMealsList(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Hero card ──────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Yellow left accent bar
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 4,
              decoration: const BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champion badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: _accent, size: 12),
                      SizedBox(width: 4),
                      Text(
                        "Champion",
                        style: TextStyle(
                          color: _accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hello Champion! 🏆",
                  style: TextStyle(
                    color: _white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Keep pushing — you're doing great",
                  style: TextStyle(color: _hint, fontSize: 12),
                ),
                const SizedBox(height: 14),
                // Progress — uses original ValueListenableBuilder + DataStore logic
                ValueListenableBuilder<int>(
                  valueListenable: DataStore.streakCount,
                  builder: (context, streak, _) {
                    final progress = (streak % 7) / 7;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Daily Progress",
                              style: TextStyle(color: _muted, fontSize: 11),
                            ),
                            Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: _accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: const Color(0xFF222222),
                            valueColor: const AlwaysStoppedAnimation<Color>(_accent),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Streaks card ───────────────────────────────────────────────
  Widget _buildStreaksCard(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StreaksScreen()),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.bolt, color: _bg, size: 24),
            ),
            const SizedBox(height: 12),
            const Text(
              "STREAKS",
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            ValueListenableBuilder<int>(
              valueListenable: DataStore.streakCount,
              builder: (_, streak, __) => Text(
                "$streak 🔥",
                style: const TextStyle(
                  color: _accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "days in a row",
              style: TextStyle(color: _hint, fontSize: 11),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _accentBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Active",
                style: TextStyle(
                  color: _accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Date card ──────────────────────────────────────────────────
  Widget _buildDateCard(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Today is ${_getTodayDate()}"),
          backgroundColor: _surface,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _accentBg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.calendar_today_outlined,
                  color: _accent, size: 20),
            ),
            const SizedBox(height: 12),
            const Text(
              "TODAY",
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getTodayDate(),
              style: const TextStyle(
                color: _white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tap for details",
              style: TextStyle(color: _hint, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ── Meals list — original ValueListenableBuilder + remove logic ─
  Widget _buildMealsList(BuildContext context) {
    return ValueListenableBuilder<Map<String, List<String>>>(
      valueListenable: DataStore.todaysMeals,
      builder: (context, mealsByType, _) {
        final hasMeals = mealsByType.values.any((list) => list.isNotEmpty);

        if (!hasMeals) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.lunch_dining_outlined,
                    color: Color(0xFF333333), size: 32),
                SizedBox(height: 8),
                Text(
                  "No meals added yet.",
                  style: TextStyle(color: _hint, fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  "Go to Meal Plan to add meals",
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: mealsByType.entries.map((entry) {
            final mealType = entry.key;
            final meals = entry.value;
            if (meals.isEmpty) return const SizedBox.shrink();

            final typeColor = getMealColor(mealType);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal type header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: typeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mealType,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        mealTimes[mealType] ?? "",
                        style: const TextStyle(color: _hint, fontSize: 11),
                      ),
                    ],
                  ),
                ),

                // Meal cards — original remove logic preserved
                ...meals.map((meal) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.fastfood_outlined,
                              color: typeColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal,
                                style: const TextStyle(
                                  color: _white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                getNutritionInfo(meal),
                                style: const TextStyle(
                                    color: _muted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        // ❌ Remove button — styled as borderless trash icon
                        GestureDetector(
                          onTap: () {
                            final updated = Map<String, List<String>>.from(
                                mealsByType);
                            updated[mealType] =
                            List<String>.from(updated[mealType]!);
                            updated[mealType]!.remove(meal);
                            DataStore.todaysMeals.value = updated;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$meal removed from $mealType"),
                                backgroundColor: _surface,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFE24B4A),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 6),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// StreaksScreen — logic 100% unchanged, UI reskinned
// ══════════════════════════════════════════════════════════════
class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});

  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  final List<int> milestones = const [50, 100, 200, 365];
  late List<Map<String, dynamic>> streakDays;

  @override
  void initState() {
    super.initState();
    _updateStreakDays();
  }

  // Original logic unchanged
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
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "YOUR STREAKS",
          style: TextStyle(
            color: _white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1E1E1E)),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: DataStore.streakCount,
        builder: (context, streak, _) {
          final achievedRewards = _getAchievedRewards(streak);
          final next = _nextMilestone(streak);
          final weekProgress = streakDays.where((d) => d["done"] as bool).length /
              streakDays.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Streak hero banner ─────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0, top: 0, bottom: 0,
                        child: Container(
                          width: 4,
                          decoration: const BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A1800),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                color: Color(0xFFE8A435),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current Streak: $streak 🔥",
                                    style: const TextStyle(
                                      color: _white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  next != -1
                                      ? Text(
                                    "Next reward at $next Meals 🎯",
                                    style: const TextStyle(
                                        color: _muted, fontSize: 12),
                                  )
                                      : const Text(
                                    "🎉 All milestones achieved!",
                                    style: TextStyle(
                                        color: _accent, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Weekly grid header ─────────────────────────
                const Text(
                  "This Week",
                  style: TextStyle(
                    color: _white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),

                // ── Weekly streak grid (original logic) ────────
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
                        color: isDone ? _accentBg : _surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isDone
                            ? [
                                BoxShadow(
                                  color: _accent.withOpacity(0.08),
                                  blurRadius: 10,
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isDone
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: isDone ? _accent : _hint,
                            size: 26,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            day["day"] as String,
                            style: TextStyle(
                              color: isDone ? _accent : _hint,
                              fontSize: 11,
                              fontWeight: isDone
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // ── Weekly progress bar ────────────────────────
                const Text(
                  "Weekly Progress",
                  style: TextStyle(
                    color: _white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Days completed",
                            style: TextStyle(color: _muted, fontSize: 12),
                          ),
                          Text(
                            "${(weekProgress * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: weekProgress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFF222222),
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(_accent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Rewards earned (original logic) ───────────
                const Text(
                  "Rewards Earned",
                  style: TextStyle(
                    color: _white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                achievedRewards.isEmpty
                    ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "No rewards yet — keep going! 💪",
                    style: TextStyle(color: _hint, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                )
                    : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: achievedRewards.map((days) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _accentBg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events,
                              color: Color(0xFFE8A435), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "$days-Day Streak",
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── Footer tip ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: _hint, size: 16),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your streak increases when you add a meal!",
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}