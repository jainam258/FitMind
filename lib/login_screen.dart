import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_dashboard.dart';
import 'parent_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;

  // Common fields
  String email = "";
  String password = "";
  String name = "";

  // Student fields
  String age = "";
  String studentClass = "";
  String height = "";
  String weight = "";
  String dietPreference = "";
  String allergies = "";
  String parentContact = "";

  // Parent fields
  String childName = "";
  String childAge = "";
  String childClass = "";
  String childHeight = "";
  String childWeight = "";
  String childDiet = "";
  String childAllergies = "";
  String parentPhone = "";

  String selectedRole = "student";

  // ── Design tokens ──────────────────────────────────────────────
  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _card = Color(0xFF222222);
  static const _border = Color(0xFF2E2E2E);
  static const _accent = Color(0xFFE8F535);
  static const _accentDark = Color(0xFF1A1A00);
  static const _textPrimary = Colors.white;
  static const _textMuted = Color(0xFF888888);
  static const _textHint = Color(0xFF555555);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      if (isLogin) {
        // LOGIN
        UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(userCred.user!.uid)
            .get();

        String role = doc.get("role");

        if (role == "student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StudentDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ParentDashboard()),
          );
        }
      } else {
        // REGISTER
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Map<String, dynamic> data = {
          "role": selectedRole,
          "email": email,
          "name": name,
          "createdAt": DateTime.now(),
        };

        if (selectedRole == "student") {
          data.addAll({
            "age": age.isEmpty ? null : int.tryParse(age),
            "class": studentClass,
            "height": height.isEmpty ? null : int.tryParse(height),
            "weight": weight.isEmpty ? null : int.tryParse(weight),
            "dietPreference": dietPreference,
            "allergies": allergies,
            "parentContact": parentContact,
          });
        } else {
          data.addAll({
            "parentPhone": parentPhone,
            "childName": childName,
            "childAge": childAge.isEmpty ? null : int.tryParse(childAge),
            "childClass": childClass,
            "childHeight":
            childHeight.isEmpty ? null : int.tryParse(childHeight),
            "childWeight":
            childWeight.isEmpty ? null : int.tryParse(childWeight),
            "childDiet": childDiet,
            "childAllergies": childAllergies,
          });
        }

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCred.user!.uid)
            .set(data);

        if (selectedRole == "student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StudentDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ParentDashboard()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Authentication Error")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Animated yellow glow background ──────────────────
          const _AnimatedYellowBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // ── Hero logo block ─────────────────────────────────
                  _buildHero(),

                  const SizedBox(height: 32),

                  // ── Form card ───────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Heading
                          Text(
                            isLogin ? "Welcome back 👋" : "Create account",
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLogin
                                ? "Log in to continue your journey"
                                : "Start your fitness journey today",
                            style: const TextStyle(
                              color: _textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Role selector (register only) ────────────
                          if (!isLogin) ...[
                            _buildLabel("Register as"),
                            const SizedBox(height: 8),
                            _buildRoleSelector(),
                            const SizedBox(height: 20),
                          ],

                          // ── Common name field ────────────────────────
                          if (!isLogin) ...[
                            _buildField("Full Name", Icons.person_outline,
                                    (val) => name = val ?? "",
                                isRequired: true),
                            const SizedBox(height: 4),
                          ],

                          // ── Student fields ───────────────────────────
                          if (!isLogin && selectedRole == "student") ...[
                            _buildField(
                                "Age", Icons.cake_outlined, (val) => age = val ?? ""),
                            _buildField("Class", Icons.class_,
                                    (val) => studentClass = val ?? ""),
                            _buildField("Height (cm)", Icons.height,
                                    (val) => height = val ?? ""),
                            _buildField("Weight (kg)", Icons.monitor_weight_outlined,
                                    (val) => weight = val ?? ""),
                            _buildField("Diet Preference", Icons.local_dining,
                                    (val) => dietPreference = val ?? ""),
                            _buildField("Allergies", Icons.warning_amber_outlined,
                                    (val) => allergies = val ?? ""),
                            _buildField("Parent Contact", Icons.phone_outlined,
                                    (val) => parentContact = val ?? ""),
                          ],

                          // ── Parent fields ────────────────────────────
                          if (!isLogin && selectedRole == "parent") ...[
                            _buildField("Parent Phone", Icons.phone_outlined,
                                    (val) => parentPhone = val ?? ""),
                            _buildField("Child Name", Icons.child_care,
                                    (val) => childName = val ?? ""),
                            _buildField("Child Age", Icons.cake_outlined,
                                    (val) => childAge = val ?? ""),
                            _buildField("Child Class", Icons.class_,
                                    (val) => childClass = val ?? ""),
                            _buildField("Child Height (cm)", Icons.height,
                                    (val) => childHeight = val ?? ""),
                            _buildField("Child Weight (kg)",
                                Icons.monitor_weight_outlined,
                                    (val) => childWeight = val ?? ""),
                            _buildField("Child Diet Preference", Icons.local_dining,
                                    (val) => childDiet = val ?? ""),
                            _buildField("Child Allergies",
                                Icons.warning_amber_outlined,
                                    (val) => childAllergies = val ?? ""),
                          ],

                          // ── Email ────────────────────────────────────
                          _buildField(
                            "Email address",
                            Icons.mail_outline,
                                (val) => email = val ?? "",
                            type: TextInputType.emailAddress,
                            isRequired: true,
                          ),

                          // ── Password ─────────────────────────────────
                          _buildField(
                            "Password",
                            Icons.lock_outline,
                                (val) => password = val ?? "",
                            obscure: true,
                            isRequired: true,
                          ),

                          // ── Forgot password (login only) ─────────────
                          if (isLogin) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    color: _accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ] else
                            const SizedBox(height: 20),

                          // ── Submit button ────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accent,
                                foregroundColor: _bg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                              ),
                              child: Text(
                                isLogin ? "LOG IN" : "CREATE ACCOUNT",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  color: _bg,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Toggle login / register ──────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = !isLogin),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: isLogin
                                          ? "New here? "
                                          : "Already have an account? ",
                                      style:
                                      const TextStyle(color: _textMuted),
                                    ),
                                    TextSpan(
                                      text: isLogin
                                          ? "Create account →"
                                          : "Log in →",
                                      style: const TextStyle(
                                        color: _accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero section ───────────────────────────────────────────────
  Widget _buildHero() {
    return Column(
      children: [
        // Glowing icon container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              "assets/images/logo3.png",
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.fitness_center,
                color: _bg,
                size: 38,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "FIT MIND",
          style: TextStyle(
            color: _textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "TRACK · TRAIN · TRANSFORM",
          style: TextStyle(
            color: _textMuted,
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),


      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _accent,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: _textMuted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 28,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  // ── Modern sliding pill selector ───────────────────────────────
  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedRole = "student"),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedRole == "student" ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Child / Student",
                  style: TextStyle(
                    color: selectedRole == "student" ? _bg : _textMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedRole = "parent"),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedRole == "parent" ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Parent",
                  style: TextStyle(
                    color: selectedRole == "parent" ? _bg : _textMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Label above field ──────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Text field ─────────────────────────────────────────────────
  Widget _buildField(
      String label,
      IconData icon,
      Function(String?) onSaved, {
        TextInputType type = TextInputType.text,
        bool obscure = false,
        bool isRequired = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        obscureText: obscure,
        keyboardType: type,
        style: const TextStyle(color: _textPrimary, fontSize: 15),
        cursorColor: _accent,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: _textHint, fontSize: 14),
          prefixIcon: Icon(icon, color: _textMuted, size: 20),
          filled: true,
          fillColor: _card,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _accent, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          errorStyle:
          const TextStyle(color: Colors.redAccent, fontSize: 11),
        ),
        validator: (val) {
          if (isRequired && (val == null || val.isEmpty)) {
            return "$label is required";
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// Animated Yellow Background
// ════════════════════════════════════════════════════════════════

class _AnimatedYellowBackground extends StatefulWidget {
  const _AnimatedYellowBackground();

  @override
  State<_AnimatedYellowBackground> createState() =>
      _AnimatedYellowBackgroundState();
}

class _AnimatedYellowBackgroundState extends State<_AnimatedYellowBackground>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _driftController;

  late Animation<double> _pulse1;
  late Animation<double> _pulse2;
  late Animation<double> _drift1x;
  late Animation<double> _drift1y;
  late Animation<double> _drift2x;
  late Animation<double> _drift2y;


  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);


    _pulse1 = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulse2 = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _drift1x = Tween<double>(begin: -30, end: 30).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOut),
    );
    _drift1y = Tween<double>(begin: -20, end: 40).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOut),
    );
    _drift2x = Tween<double>(begin: 20, end: -40).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOut),
    );
    _drift2y = Tween<double>(begin: 30, end: -20).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOut),
    );
}

  @override
  void dispose() {
    _pulseController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge(
          [_pulseController, _driftController]),
      builder: (context, _) {
        return CustomPaint(
          size: size,
          painter: _YellowGlowPainter(
            pulse1: _pulse1.value,
            pulse2: _pulse2.value,
            drift1x: _drift1x.value,
            drift1y: _drift1y.value,
            drift2x: _drift2x.value,
            drift2y: _drift2y.value,
          ),
        );
      },
    );
  }
}



// ── Custom painter ─────────────────────────────────────────────
class _YellowGlowPainter extends CustomPainter {
  final double pulse1;
  final double pulse2;
  final double drift1x;
  final double drift1y;
  final double drift2x;
  final double drift2y;

  static const _yellow = Color(0xFFE8F535);

  _YellowGlowPainter({
    required this.pulse1,
    required this.pulse2,
    required this.drift1x,
    required this.drift1y,
    required this.drift2x,
    required this.drift2y,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Large ambient orbs ─────────────────────────────────────

    // Orb 1 — top-left drift
    final orb1Center = Offset(
      size.width * 0.15 + drift1x,
      size.height * 0.12 + drift1y,
    );
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          _yellow.withOpacity(0.18 * pulse1),
          _yellow.withOpacity(0.06 * pulse1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb1Center, radius: 200));
    canvas.drawCircle(orb1Center, 200, orb1Paint);

    // Orb 2 — bottom-right drift
    final orb2Center = Offset(
      size.width * 0.85 + drift2x,
      size.height * 0.78 + drift2y,
    );
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          _yellow.withOpacity(0.14 * pulse2),
          _yellow.withOpacity(0.05 * pulse2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb2Center, radius: 220));
    canvas.drawCircle(orb2Center, 220, orb2Paint);

    // Orb 3 — center subtle pulse
    final orb3Center = Offset(size.width * 0.5, size.height * 0.42);
    final orb3Radius = 160.0 + 30 * pulse1;
    final orb3Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          _yellow.withOpacity(0.07 * pulse2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: orb3Center, radius: orb3Radius));
    canvas.drawCircle(orb3Center, orb3Radius, orb3Paint);


    // ── ECG / heartbeat line at bottom ─────────────────────────
    //_drawHeartbeatLine(canvas, size);
  }



  @override
  bool shouldRepaint(covariant _YellowGlowPainter old) => true;
}