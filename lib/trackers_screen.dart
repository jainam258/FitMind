import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key});

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen> with SingleTickerProviderStateMixin {
  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color primaryColor = Color(0xFFE8F535);
  static const Color textMuted = Color(0xFF8B949E);
  
  late TabController _tabController;

  // Pedometer State
  Stream<StepCount>? _stepCountStream;
  int _baselineSteps = 0;
  int _todayLiveSteps = 0;
  String _pedometerStatus = 'unknown';

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get _fitnessLogsRef =>
      FirebaseFirestore.instance.collection('users').doc(_uid).collection('fitness_logs');

  CollectionReference get _mealLogsRef =>
      FirebaseFirestore.instance.collection('users').doc(_uid).collection('meal_logs');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initPedometer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- PEDOMETER LOGIC ---
  Future<void> _initPedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      final prefs = await SharedPreferences.getInstance();
      final today = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      final storedDate = prefs.getString("step_date");

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream?.listen((event) {
        if (storedDate != today) {
           prefs.setString("step_date", today);
           prefs.setInt("baseline_steps", event.steps);
           _baselineSteps = event.steps;
        } else {
           _baselineSteps = prefs.getInt("baseline_steps") ?? event.steps;
        }
        if (mounted) {
          setState(() {
            _todayLiveSteps = event.steps - _baselineSteps;
            if (_todayLiveSteps < 0) _todayLiveSteps = 0;
            _pedometerStatus = 'tracking';
          });
        }
      }, onError: (error) {
        debugPrint("Pedometer Error: $error");
        if (mounted) {
          setState(() => _pedometerStatus = 'unavailable');
        }
      });
    } else {
      if (mounted) {
        setState(() => _pedometerStatus = 'permission_denied');
      }
    }
  }

  // --- DATES FOR CHARTS ---
  String get _todayDateStr {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  List<String> get _last7DaysStrings {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return '${day.day}/${day.month}/${day.year}';
    });
  }

  List<String> get _last7DayLabels {
    final now = DateTime.now();
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return dayNames[day.weekday - 1];
    });
  }

  // --- UI BUILDING ---
  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Text("Please login to view your trackers", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        title: const Text(
          "Trackers",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: textMuted,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "Steps"),
            Tab(text: "Calories"),
            Tab(text: "Water"),
            Tab(text: "Protein"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLogDialog(context),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fitnessLogsRef.orderBy('timestamp', descending: false).snapshots(),
        builder: (context, fitnessSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: _mealLogsRef.orderBy('timestamp', descending: false).snapshots(),
            builder: (context, mealSnapshot) {
              if (!fitnessSnapshot.hasData || !mealSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              }

              final fitnessDocs = fitnessSnapshot.data!.docs;
              final mealDocs = mealSnapshot.data!.docs;

              final last7Days = _last7DaysStrings;
              final dayLabels = _last7DayLabels;

              // Parse Data arrays
              List<FlSpot> stepsData = [];
              List<FlSpot> caloriesData = [];
              List<FlSpot> waterData = [];
              List<FlSpot> proteinData = [];

              double todayWater = 0;
              double todayCalories = 0;
              double todayProtein = 0;

              for (int i = 0; i < 7; i++) {
                String date = last7Days[i];
                double dailySteps = 0, dailyCals = 0, dailyWater = 0, dailyProtein = 0;

                // Fitness
                for (var doc in fitnessDocs) {
                  final d = doc.data() as Map<String, dynamic>;
                  if (d['date'] == date) {
                    dailySteps += (d['steps'] ?? 0);
                    dailyCals += (d['caloriesBurned'] ?? 0);
                    dailyWater += (d['waterIntake'] ?? 0);
                  }
                }
                // Meals
                for (var doc in mealDocs) {
                  final d = doc.data() as Map<String, dynamic>;
                  if (d['date'] == date) {
                    dailyProtein += (d['protein'] ?? 0);
                  }
                }

                stepsData.add(FlSpot(i.toDouble(), dailySteps));
                caloriesData.add(FlSpot(i.toDouble(), dailyCals));
                waterData.add(FlSpot(i.toDouble(), dailyWater));
                proteinData.add(FlSpot(i.toDouble(), dailyProtein));

                if (i == 6) { // Today
                  todayWater = dailyWater;
                  todayCalories = dailyCals;
                  todayProtein = dailyProtein;
                }
              }

              // Overwrite today's steps with live pedometer data if available
              if (_pedometerStatus == 'tracking' && _todayLiveSteps > 0) {
                 stepsData[6] = FlSpot(6, _todayLiveSteps.toDouble());
              } else {
                 _todayLiveSteps = stepsData[6].y.toInt(); // fallback to manual logs
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildStepsTab(stepsData, dayLabels),
                  _buildCaloriesTab(caloriesData, dayLabels, todayCalories),
                  _buildWaterTab(waterData, dayLabels, todayWater),
                  _buildProteinTab(proteinData, dayLabels, todayProtein),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // --- TABS ---
  
  Widget _buildStepsTab(List<FlSpot> data, List<String> labels) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Hero Section
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_run_rounded, size: 60, color: primaryColor.withOpacity(0.9)),
              const SizedBox(height: 15),
              Text(
                "$_todayLiveSteps",
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const Text("STEPS TODAY", style: TextStyle(color: primaryColor, letterSpacing: 2, fontWeight: FontWeight.bold)),
              if (_pedometerStatus == 'unavailable' || _pedometerStatus == 'permission_denied')
                 const Padding(
                   padding: EdgeInsets.only(top: 8.0),
                   child: Text("Hardware sensor unavailable - using manual logs", style: TextStyle(color: textMuted, fontSize: 10)),
                 )
              else
                 const Padding(
                   padding: EdgeInsets.only(top: 8.0),
                   child: Text("Live tracking active 🟢", style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                 )
            ],
          ),
        ),
        const SizedBox(height: 30),
        buildChart(data, "Steps History", Icons.show_chart, labels),
      ],
    );
  }

  Widget _buildWaterTab(List<FlSpot> data, List<String> labels, double todayWater) {
    double goal = 3.0; // 3 Liters
    double percent = (todayWater / goal).clamp(0.0, 1.0);
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Hero Liquid Progress
        SizedBox(
          height: 250,
          child: Center(
            child: SizedBox(
              height: 200, width: 200,
              child: LiquidCircularProgressIndicator(
                value: percent,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF2196F3)),
                backgroundColor: cardColor,
                borderColor: primaryColor,
                borderWidth: 2.0,
                direction: Axis.vertical,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${todayWater.toStringAsFixed(1)}L", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text("of 3.0L", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        buildChart(data, "Water History (L)", Icons.water_drop, labels),
      ],
    );
  }

  Widget _buildCaloriesTab(List<FlSpot> data, List<String> labels, double todayCals) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 160, width: 160,
                child: CircularProgressIndicator(
                  value: (todayCals / 1000).clamp(0.0, 1.0),
                  strokeWidth: 12,
                  color: Colors.orangeAccent,
                  backgroundColor: Colors.orangeAccent.withOpacity(0.1),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 30),
                  Text("${todayCals.toInt()}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("KCAL BURNED", style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        buildChart(data, "Calories History", Icons.local_fire_department, labels),
      ],
    );
  }

  Widget _buildProteinTab(List<FlSpot> data, List<String> labels, double todayProtein) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 160, width: 160,
                child: CircularProgressIndicator(
                  value: (todayProtein / 150).clamp(0.0, 1.0),
                  strokeWidth: 12,
                  color: primaryColor,
                  backgroundColor: primaryColor.withOpacity(0.1),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant, color: primaryColor, size: 30),
                  Text("${todayProtein.toInt()}g", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("PROTEIN", style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        buildChart(data, "Protein History (g)", Icons.restaurant, labels),
      ],
    );
  }

  // --- CHART BUILDER ---
  Widget buildChart(List<FlSpot> data, String title, IconData icon, List<String> dayLabels) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: data.every((spot) => spot.y == 0)
                ? const Center(child: Text("No data yet.", style: TextStyle(color: textMuted, fontSize: 13)))
                : LineChart(
                    LineChartData(
                      backgroundColor: Colors.transparent,
                      gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 0.8)),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              if (idx < 0 || idx >= dayLabels.length) return const SizedBox();
                              return Padding(padding: const EdgeInsets.only(top: 8), child: Text(dayLabels[idx], style: const TextStyle(color: textMuted, fontSize: 9)));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, reservedSize: 34,
                            getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(0), style: const TextStyle(color: textMuted, fontSize: 9)),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data, isCurved: true, color: primaryColor, barWidth: 3.5, dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [primaryColor.withOpacity(0.18), primaryColor.withOpacity(0.01)]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // --- LOG DIALOG ---
  void _showAddLogDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final workoutTypeController = TextEditingController();
    final stepsController = TextEditingController();
    final caloriesController = TextEditingController();
    final workoutMinutesController = TextEditingController();
    final waterController = TextEditingController();
    final proteinController = TextEditingController(); // new
    bool isSaving = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF0F1319), borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Log Activity ⚡", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18),
                      _buildDialogField("Steps Count", stepsController, Icons.directions_walk, keyboard: TextInputType.number),
                      _buildDialogField("Calories Burned (kcal)", caloriesController, Icons.local_fire_department, keyboard: TextInputType.number),
                      _buildDialogField("Water Intake (L)", waterController, Icons.water_drop_outlined, keyboard: const TextInputType.numberWithOptions(decimal: true)),
                      _buildDialogField("Protein (g)", proteinController, Icons.restaurant, keyboard: TextInputType.number),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity, height: 52,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : () async {
                            setDialogState(() => isSaving = true);
                            try {
                              final now = DateTime.now();
                              final dateStr = '${now.day}/${now.month}/${now.year}';
                              await _fitnessLogsRef.add({
                                'steps': int.tryParse(stepsController.text.trim()) ?? 0,
                                'caloriesBurned': int.tryParse(caloriesController.text.trim()) ?? 0,
                                'waterIntake': double.tryParse(waterController.text.trim()) ?? 0.0,
                                'date': dateStr, 'timestamp': FieldValue.serverTimestamp(), 'userId': _uid,
                              });
                              if (proteinController.text.isNotEmpty) {
                                await _mealLogsRef.add({
                                  'protein': int.tryParse(proteinController.text.trim()) ?? 0,
                                  'date': dateStr, 'timestamp': FieldValue.serverTimestamp(), 'userId': _uid,
                                  'mealName': 'Manual Log'
                                });
                              }
                              if (mounted) Navigator.pop(context);
                            } finally {
                              if (mounted) setDialogState(() => isSaving = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                          child: isSaving ? const CircularProgressIndicator(color: Colors.black) : const Text("Save Log", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: const Color(0xFF1B222C), borderRadius: BorderRadius.circular(14)),
      child: TextFormField(
        controller: controller, keyboardType: keyboard, style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(icon: Icon(icon, color: primaryColor, size: 20), hintText: label, hintStyle: const TextStyle(color: textMuted, fontSize: 14), border: InputBorder.none),
      ),
    );
  }
}