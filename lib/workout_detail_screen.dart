import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Map<String, dynamic> plan;

  const WorkoutDetailScreen({super.key, required this.plan});

  static const Color bgColor = Color(0xFF0D0D0E);
  static const Color cardColor = Color(0xFF161B22);
  static const Color primaryColor = Color(0xFFD9FF3F);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Color(0xFF8B949E);
  static const Color accentColor = Color(0xFFB388FF);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> exercises = plan["exercises"] ?? [];
    final List<dynamic> benefits = plan["benefits"] ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Sleek Hero App Bar with a beautiful photo background
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: bgColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              title: Text(
                plan["title"] ?? "Workout Details",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    plan["imageUrl"] ??
                        "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600&auto=format&fit=crop",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: cardColor,
                      child: const Icon(
                        Icons.fitness_center,
                        color: primaryColor,
                        size: 64,
                      ),
                    ),
                  ),
                  // Bottom gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                          bgColor,
                        ],
                        stops: [0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Workout stats and details content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Brief Description
                  Text(
                    plan["desc"] ?? "",
                    style: const TextStyle(
                      color: subtitleColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          Icons.timer_outlined,
                          "DURATION",
                          plan["duration"] ?? "N/A",
                          primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          Icons.local_fire_department_outlined,
                          "BURN",
                          plan["caloriesBurned"] ?? "N/A",
                          const Color(0xFFFF5252),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          Icons.fitness_center_outlined,
                          "TARGET",
                          plan["focus"] ?? "N/A",
                          accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Difficulty and Info Chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(plan["difficulty"] ?? "")
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getDifficultyColor(plan["difficulty"] ?? "")
                                .withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 14,
                              color:
                                  _getDifficultyColor(plan["difficulty"] ?? ""),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${plan["difficulty"] ?? "Intermediate"} Level",
                              style: TextStyle(
                                color: _getDifficultyColor(
                                    plan["difficulty"] ?? ""),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt,
                              size: 14,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${exercises.length} Exercises",
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Benefits section ("What you get")
                  if (benefits.isNotEmpty) ...[
                    const Text(
                      "What You'll Achieve",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF30363D),
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        children: benefits.map<Widget>((benefit) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    benefit.toString(),
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Exercises Title
                  const Text(
                    "Workout Poses & Routine",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // Exercise List
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ex = exercises[index];
                  return _ExerciseExpansionCard(
                    exercise: ex,
                    index: index + 1,
                  );
                },
                childCount: exercises.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case "beginner":
        return const Color(0xFF4CAF50);
      case "advanced":
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFFFFC107);
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF30363D), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ExerciseExpansionCard extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final int index;

  const _ExerciseExpansionCard({required this.exercise, required this.index});

  @override
  State<_ExerciseExpansionCard> createState() => _ExerciseExpansionCardState();
}

class _ExerciseExpansionCardState extends State<_ExerciseExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: WorkoutDetailScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? WorkoutDetailScreen.primaryColor.withOpacity(0.3)
              : const Color(0xFF30363D),
          width: 0.8,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(
                  widget.exercise["poseImageUrl"] ??
                      "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600&auto=format&fit=crop",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            "${widget.index}. ${widget.exercise["name"]}",
            style: const TextStyle(
              color: WorkoutDetailScreen.textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.exercise["durationOrReps"] ?? "",
                    style: const TextStyle(
                      color: WorkoutDetailScreen.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "• ${widget.exercise["targetMuscle"] ?? ""}",
                    style: const TextStyle(
                      color: WorkoutDetailScreen.subtitleColor,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: _isExpanded
                ? WorkoutDetailScreen.primaryColor
                : WorkoutDetailScreen.subtitleColor,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFF30363D), height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    "HOW TO PERFORM:",
                    style: TextStyle(
                      color: WorkoutDetailScreen.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.exercise["description"] ?? "Instructions not provided.",
                    style: const TextStyle(
                      color: WorkoutDetailScreen.textColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
