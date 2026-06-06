import 'package:flutter/material.dart';
import 'workout_detail_screen.dart';

class WorkoutPlansScreen extends StatelessWidget {
  const WorkoutPlansScreen({super.key});

  static const Color bgColor = Color(0xFF0D0D0E);
  static const Color cardColor = Color(0xFF161B22);
  static const Color primaryColor = Color(0xFFD9FF3F);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Color(0xFF8B949E);

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        "title": "Home Workout",
        "imageUrl": "https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?q=80&w=600&auto=format&fit=crop",
        "duration": "15-40 min",
        "caloriesBurned": "180-300 kcal",
        "focus": "Full Body",
        "difficulty": "Beginner",
        "desc": "No equipment full-body workouts.",
        "benefits": [
          "Requires no gym equipment or travel",
          "Improves overall body strength using body weight",
          "Enhances cardiovascular health and circulation",
          "Easy to follow and customizable for all ages"
        ],
        "exercises": [
          {
            "name": "Jumping Jacks",
            "durationOrReps": "3 sets x 45 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Full Body / Cardio",
            "description": "Stand with feet together and arms at your sides. Jump your feet out to the sides while raising your arms above your head. Return to starting position rapidly."
          },
          {
            "name": "Push-ups",
            "durationOrReps": "3 sets x 10 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Chest & Triceps",
            "description": "Keep your hands slightly wider than shoulder-width, lower your body until your chest almost touches the floor, keep your core tight, and push back up."
          },
          {
            "name": "Bodyweight Squats",
            "durationOrReps": "3 sets x 15 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1574680178050-55c6a6a96e0a?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Quads & Glutes",
            "description": "Stand with feet shoulder-width apart. Lower your hips down and back as if sitting in a chair, keeping your chest up and knees behind your toes."
          },
          {
            "name": "Plank Hold",
            "durationOrReps": "3 sets x 30 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1566241477600-ac026ad43874?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Core",
            "description": "Support your weight on your forearms and toes, keeping your body in a straight line from head to heels. Engage your abs and hold."
          }
        ]
      },
      {
        "title": "Gym Workout",
        "imageUrl": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=600&auto=format&fit=crop",
        "duration": "45-75 min",
        "caloriesBurned": "350-500 kcal",
        "focus": "Hypertrophy",
        "difficulty": "Advanced",
        "desc": "Strength and muscle building plans.",
        "benefits": [
          "Builds raw muscular strength and power",
          "Increases bone mineral density and joint stability",
          "Improves overall body posture and structural form",
          "Maximizes protein synthesis & muscle hypertrophy"
        ],
        "exercises": [
          {
            "name": "Barbell Squats",
            "durationOrReps": "4 sets x 8 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Quads & Glutes",
            "description": "Rest the barbell on your upper back. Squat down until thighs are parallel to the floor, then push back up."
          },
          {
            "name": "Bench Press",
            "durationOrReps": "4 sets x 8 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Chest & Triceps",
            "description": "Lie flat on a bench, grip the barbell slightly wider than shoulder-width, lower the bar to your mid-chest, and press it back up."
          },
          {
            "name": "Lat Pulldown",
            "durationOrReps": "3 sets x 10 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Lats & Upper Back",
            "description": "Sit at a pulldown station. Pull the bar down to your upper chest, squeezing your shoulder blades together."
          }
        ]
      },
      {
        "title": "Fat Loss",
        "imageUrl": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600&auto=format&fit=crop",
        "duration": "20-45 min",
        "caloriesBurned": "300-450 kcal",
        "focus": "Cardio / HIIT",
        "difficulty": "Intermediate",
        "desc": "Burn calories with HIIT routines.",
        "benefits": [
          "Accelerates active calorie burning in less time",
          "Improves resting heart rate & overall endurance",
          "Induces afterburn (EPOC) effect, burning fat post-workout",
          "Highly efficient for busy schedules"
        ],
        "exercises": [
          {
            "name": "Burpees",
            "durationOrReps": "3 sets x 12 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Full Body / Cardio",
            "description": "Drop into a squat, kick feet back to a push-up position, return to squat, and jump high into the air."
          },
          {
            "name": "Mountain Climbers",
            "durationOrReps": "3 sets x 40 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1483721310020-03333e577078?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Core & Shoulders",
            "description": "From a plank position, drive your knees in towards your chest one at a time as quickly as possible, keeping your back flat."
          },
          {
            "name": "Kettlebell Swings",
            "durationOrReps": "3 sets x 15 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Glutes & Hamstrings",
            "description": "Hinge at the hips, swing the kettlebell between your legs, and drive your hips forward to swing the kettlebell to eye level."
          }
        ]
      },
      {
        "title": "Muscle Gain",
        "imageUrl": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=600&auto=format&fit=crop",
        "duration": "50-90 min",
        "caloriesBurned": "280-400 kcal",
        "focus": "Hypertrophy",
        "difficulty": "Advanced",
        "desc": "Build lean muscle effectively.",
        "benefits": [
          "Promotes substantial lean muscle mass increase",
          "Elevates metabolic rate & overall energy consumption",
          "Enhances structural physical strength & body definition",
          "Fortifies joints and prevents future sports injuries"
        ],
        "exercises": [
          {
            "name": "Deadlifts",
            "durationOrReps": "4 sets x 6 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Hamstrings & Back",
            "description": "Stand with feet mid-foot under the bar. Hinge at hips, bend knees, grip bar, and stand up, pulling the bar up along your shins."
          },
          {
            "name": "Overhead Press",
            "durationOrReps": "3 sets x 8 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Shoulders & Triceps",
            "description": "Hold barbell at shoulder height, squeeze glutes and core, then press the bar straight up overhead until arms lock out."
          },
          {
            "name": "Dumbbell Bicep Curls",
            "durationOrReps": "3 sets x 12 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Biceps",
            "description": "Hold dumbbells at sides with palms facing forward. Curl the weights up while keeping your elbows tucked close to your torso."
          }
        ]
      },
      {
        "title": "Abs & Core",
        "imageUrl": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=600&auto=format&fit=crop",
        "duration": "10-30 min",
        "caloriesBurned": "100-180 kcal",
        "focus": "Core Strength",
        "difficulty": "Intermediate",
        "desc": "Strong core and visible abs.",
        "benefits": [
          "Significantly improves spine alignment and posture",
          "Decreases risk of lower back strain and injury",
          "Tones abdominal muscles and tightens midsection",
          "Improves balance, stability, and rotational strength"
        ],
        "exercises": [
          {
            "name": "Ab Crunches",
            "durationOrReps": "3 sets x 20 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Upper Abs",
            "description": "Lie on your back with knees bent. Lift your shoulders off the floor, engaging your abs at the top, and slowly lower back down."
          },
          {
            "name": "Bicycle Crunches",
            "durationOrReps": "3 sets x 15 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1566241477600-ac026ad43874?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Obliques & Abs",
            "description": "Lie flat, bring elbow to opposite knee while extending the other leg, alternating in a pedaling motion."
          },
          {
            "name": "Russian Twists",
            "durationOrReps": "3 sets x 20 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Obliques",
            "description": "Sit with knees bent, feet elevated off the floor, and twist your torso from side to side, touching the floor on each side."
          }
        ]
      },
      {
        "title": "Stretching",
        "imageUrl": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=600&auto=format&fit=crop",
        "duration": "15-30 min",
        "caloriesBurned": "80-120 kcal",
        "focus": "Flexibility",
        "difficulty": "Beginner",
        "desc": "Flexibility and mobility sessions.",
        "benefits": [
          "Maintains elasticity and flexibility of muscles",
          "Aids in quick post-workout recovery and stiffness relief",
          "Promotes muscle relaxation and mental stress relief",
          "Corrects structural imbalances caused by sitting"
        ],
        "exercises": [
          {
            "name": "Cobra Stretch",
            "durationOrReps": "3 sets x 30 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Lower Back & Abs",
            "description": "Lie face down, place hands under shoulders, and gently push your chest up off the floor, keeping hips resting on the mat."
          },
          {
            "name": "Child's Pose",
            "durationOrReps": "3 sets x 45 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Lower Back & Glutes",
            "description": "Kneel on the floor, sit back on your heels, and reach your arms forward on the floor, letting your forehead rest."
          },
          {
            "name": "Hamstring Stretch",
            "durationOrReps": "3 sets x 30 sec",
            "poseImageUrl": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Hamstrings",
            "description": "Sit on the floor, extend one leg out, bend the other foot in, and reach forward to touch your toes, holding the stretch."
          }
        ]
      },
      {
        "title": "Beginner Plan",
        "imageUrl": "https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80&w=600&auto=format&fit=crop",
        "duration": "15-25 min",
        "caloriesBurned": "120-180 kcal",
        "focus": "Adaptation",
        "difficulty": "Beginner",
        "desc": "Perfect for beginners.",
        "benefits": [
          "Introduces fundamental movements safely",
          "Builds coordination and muscle memory",
          "Low impact to minimize soreness",
          "Establishes a solid training habit foundation"
        ],
        "exercises": [
          {
            "name": "Glute Bridges",
            "durationOrReps": "3 sets x 12 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1574680096145-d05b474e2155?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Glutes & Hamstrings",
            "description": "Lie on your back, knees bent, feet flat on the floor. Lift hips towards the ceiling, squeeze glutes, and lower."
          },
          {
            "name": "Knee Push-ups",
            "durationOrReps": "3 sets x 10 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Chest & Shoulders",
            "description": "Similar to a standard pushup, but keep your knees resting on the floor to reduce the load on upper body muscles."
          },
          {
            "name": "Bird Dog",
            "durationOrReps": "3 sets x 10 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1566241477600-ac026ad43874?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Lower Back & Core",
            "description": "On hands and knees, extend opposite arm and opposite leg parallel to the floor. Hold briefly, then return and switch."
          }
        ]
      },
      {
        "title": "Advanced Training",
        "imageUrl": "https://images.unsplash.com/photo-1517963879433-6ad2b056d712?q=80&w=600&auto=format&fit=crop",
        "duration": "45-90 min",
        "caloriesBurned": "400-650 kcal",
        "focus": "Athletic Power",
        "difficulty": "Advanced",
        "desc": "Challenge your limits.",
        "benefits": [
          "Pushes physical limitations and athletic margins",
          "Significantly improves peak metabolic throughput",
          "Optimizes anaerobic endurance limits",
          "Maximizes total power, density, and agility"
        ],
        "exercises": [
          {
            "name": "Pistol Squats",
            "durationOrReps": "3 sets x 6 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1517963879433-6ad2b056d712?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Single Leg Quads",
            "description": "Stand on one leg, lift the opposite leg straight forward, lower yourself into a single-leg squat, and stand back up."
          },
          {
            "name": "Diamond Push-ups",
            "durationOrReps": "3 sets x 12 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Triceps & Chest",
            "description": "Form a diamond shape with your thumbs and index fingers under your chest. Perform push-ups with tucked elbows."
          },
          {
            "name": "Pull-ups",
            "durationOrReps": "4 sets x 8 reps",
            "poseImageUrl": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=400&auto=format&fit=crop",
            "targetMuscle": "Lats & Biceps",
            "description": "Hang from a bar, grip overhand wider than shoulder-width, and pull your body up until your chin clears the bar."
          }
        ]
      }
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Workout Plans",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner introducing Workout section
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF30363D), width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Choose Your Fitness Journey",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Select a workout plan based on your goals, targets, and availability.",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Workout Plans Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: plans.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final plan = plans[index];
                final difficulty = plan["difficulty"] as String;
                final exercisesList = plan["exercises"] as List;

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDetailScreen(plan: plan),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF30363D),
                        width: 0.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background Image
                          Image.network(
                            plan["imageUrl"] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: cardColor,
                              child: const Icon(
                                Icons.fitness_center_outlined,
                                color: primaryColor,
                                size: 40,
                              ),
                            ),
                          ),

                          // Gradient Overlay for readability
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                  Colors.black87,
                                ],
                                stops: [0.3, 0.7, 1.0],
                              ),
                            ),
                          ),

                          // Card Content
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Difficulty Pill
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor(difficulty)
                                          .withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      difficulty,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Title
                                Text(
                                  plan["title"] as String,
                                  style: const TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Exercises Count
                                Text(
                                  "${exercisesList.length} Exercises",
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Duration
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      size: 12,
                                      color: subtitleColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        plan["duration"] as String,
                                        style: const TextStyle(
                                          color: subtitleColor,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
}