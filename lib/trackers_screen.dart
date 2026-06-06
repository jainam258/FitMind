import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key});

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen> {
  static const Color bgColor = Color(0xFF0D0D0D);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color primaryColor = Color(0xFFD9FF3F);
  static const Color textMuted = Color(0xFF8B949E);

  // ── Stat Card without borders ──────────────────────────────────
  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: primaryColor, size: 26),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Styled Bezier Chart with touch tooltips and no borders ─────
  Widget buildChart(List<FlSpot> data, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: data.isEmpty
                ? const Center(
                    child: Text(
                      "No data yet. Log some workouts!",
                      style: TextStyle(color: textMuted, fontSize: 13),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: const Color(0xFF1E2530),
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                spot.y.toStringAsFixed(0),
                                const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: Colors.white10,
                          strokeWidth: 0.8,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "Log ${idx + 1}",
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 9,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: textMuted,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                          isCurved: true,
                          color: primaryColor,
                          barWidth: 3.5,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                primaryColor.withOpacity(0.18),
                                primaryColor.withOpacity(0.01),
                              ],
                            ),
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

  // ── Logging dialog ─────────────────────────────────────────────
  void _showAddLogDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final workoutTypeController = TextEditingController();
    final stepsController = TextEditingController();
    final caloriesController = TextEditingController();
    final workoutMinutesController = TextEditingController();
    final waterController = TextEditingController();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0F1319),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Log Fitness Activity ⚡",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        
                        // Workout type field
                        _buildDialogField("Workout Type (e.g. Walking, Run)", workoutTypeController, Icons.fitness_center),
                        _buildDialogField("Steps Count", stepsController, Icons.directions_walk, keyboard: TextInputType.number),
                        _buildDialogField("Calories Burned (kcal)", caloriesController, Icons.local_fire_department, keyboard: TextInputType.number),
                        _buildDialogField("Workout Duration (min)", workoutMinutesController, Icons.timer_outlined, keyboard: TextInputType.number),
                        _buildDialogField("Water Intake (L)", waterController, Icons.water_drop_outlined, keyboard: const TextInputType.numberWithOptions(decimal: true)),
                        
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isSaving ? null : () async {
                              if (!formKey.currentState!.validate()) return;
                              setDialogState(() => isSaving = true);
                              try {
                                final now = DateTime.now();
                                await FirebaseFirestore.instance.collection('fitness_logs').add({
                                  'steps': int.tryParse(stepsController.text.trim()) ?? 0,
                                  'caloriesBurned': int.tryParse(caloriesController.text.trim()) ?? 0,
                                  'workoutMinutes': int.tryParse(workoutMinutesController.text.trim()) ?? 0,
                                  'waterIntake': double.tryParse(waterController.text.trim()) ?? 0.0,
                                  'workoutType': workoutTypeController.text.trim().isNotEmpty
                                      ? workoutTypeController.text.trim()
                                      : 'Workout',
                                  'date': '${now.day}/${now.month}/${now.year}',
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("🎉 Fitness log recorded successfully!"),
                                      backgroundColor: cardColor,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              } finally {
                                if (mounted) setDialogState(() => isSaving = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                                  )
                                : const Text("Save Log", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B222C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: primaryColor, size: 20),
          hintText: label,
          hintStyle: const TextStyle(color: textMuted, fontSize: 14),
          border: InputBorder.none,
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Tracker your Day",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLogDialog(context),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('fitness_logs').orderBy('timestamp', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final docs = snapshot.data!.docs;

          List<FlSpot> stepsData = [];
          List<FlSpot> caloriesData = [];
          List<FlSpot> workoutData = [];
          List<FlSpot> waterData = [];

          num totalSteps = 0;
          num totalCalories = 0;
          num totalWorkout = 0;
          double totalWater = 0;

          for (int i = 0; i < docs.length; i++) {
            final data = docs[i].data() as Map<String, dynamic>;

            final steps = (data['steps'] ?? 0).toDouble();
            final calories = (data['caloriesBurned'] ?? 0).toDouble();
            final workout = (data['workoutMinutes'] ?? 0).toDouble();
            final water = (data['waterIntake'] ?? 0).toDouble();

            stepsData.add(FlSpot(i.toDouble(), steps));
            caloriesData.add(FlSpot(i.toDouble(), calories));
            workoutData.add(FlSpot(i.toDouble(), workout));
            waterData.add(FlSpot(i.toDouble(), water));

            totalSteps += steps.toInt();
            totalCalories += calories.toInt();
            totalWorkout += workout.toInt();
            totalWater += water;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // extra padding at bottom for FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Fitness Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    statCard("Steps", totalSteps.toString(), Icons.directions_walk),
                    statCard("Calories", totalCalories.toString(), Icons.local_fire_department),
                    statCard("Workout", "$totalWorkout min", Icons.fitness_center),
                    statCard("Water", "${totalWater.toStringAsFixed(1)} L", Icons.water_drop),
                  ],
                ),

                const SizedBox(height: 24),

                buildChart(stepsData, "Steps Progress", Icons.directions_walk),
                buildChart(caloriesData, "Calories Burned", Icons.local_fire_department),
                buildChart(workoutData, "Workout Minutes", Icons.fitness_center),
                buildChart(waterData, "Water Intake", Icons.water_drop),

                // Recent Activities Card without borders
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
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
                      const Text(
                        "Recent Activities",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      docs.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "No activities logged yet.",
                                  style: TextStyle(color: textMuted, fontSize: 13),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: docs.length > 5 ? 5 : docs.length,
                              itemBuilder: (context, index) {
                                // Show in reverse order (newest first)
                                final docIndex = docs.length - 1 - index;
                                final data = docs[docIndex].data() as Map<String, dynamic>;
                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: primaryColor.withOpacity(0.12),
                                        child: const Icon(Icons.flash_on, color: primaryColor, size: 20),
                                      ),
                                      title: Text(
                                        data['workoutType'] ?? 'Workout',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        data['date'] ?? '',
                                        style: const TextStyle(color: textMuted, fontSize: 12),
                                      ),
                                      trailing: Text(
                                        "${(data['workoutMinutes'] ?? 0)} min",
                                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (index < (docs.length > 5 ? 4 : docs.length - 1))
                                      const Divider(color: Colors.white10, height: 1),
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
        },
      ),
    );
  }
}