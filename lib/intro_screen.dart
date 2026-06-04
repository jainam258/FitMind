import 'package:flutter/material.dart';
import 'data_store.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentStep = 0;

  final PageController _controller = PageController();

  final List<String> _questions = [
    "How do you feel emotionally right now?",
    "Did you sleep well last night?",
    "Are you ready to fuel up for success?",
  ];

  final List<IconData> _questionIcons = [
    Icons.sentiment_satisfied_alt_outlined,
    Icons.bedtime_outlined,
    Icons.bolt_outlined,
  ];

  final List<String> _labels = [
    "Very Poor",
    "Poor",
    "Average",
    "Good",
    "Excellent",
  ];

  void _nextPage(int score) {
    QnAStore.answers.add(score);

    if (_currentStep < _questions.length - 1) {
      setState(() {
        _currentStep++;
      });

      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                12,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "FITMIND",
                        style: TextStyle(
                          color: Color(0xFFD9FF3F),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        "${_currentStep + 1}/${_questions.length}",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value:
                      (_currentStep + 1) /
                          _questions.length,
                      minHeight: 8,
                      backgroundColor:
                      const Color(0xFF1E2530),
                      valueColor:
                      const AlwaysStoppedAnimation(
                        Color(0xFFD9FF3F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // ICON
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                            const LinearGradient(
                              colors: [
                                Color(0xFFD9FF3F),
                                Color(0xFFB8F92E),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                const Color(
                                  0xFFD9FF3F,
                                ).withOpacity(0.25),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            _questionIcons[index],
                            color: Colors.black,
                            size: 50,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text(
                          _questions[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Help us personalize your fitness experience",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 28),

                        ...List.generate(
                          5,
                              (i) {
                            final score = i + 1;

                            return Padding(
                              padding:
                              const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),
                                onTap: () =>
                                    _nextPage(score),
                                child: Container(
                                  width:
                                  double.infinity,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xFF151A22,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      18,
                                    ),
                                    border: Border.all(
                                      color:
                                      Colors.white
                                          .withOpacity(
                                        0.05,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration:
                                        BoxDecoration(
                                          color:
                                          const Color(
                                            0xFFD9FF3F,
                                          ),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$score",
                                            style:
                                            const TextStyle(
                                              color:
                                              Colors
                                                  .black,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              fontSize:
                                              16,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 14,
                                      ),

                                      Expanded(
                                        child: Text(
                                          _labels[i],
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors
                                                .white,
                                            fontSize:
                                            15,
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ),

                                      const Icon(
                                        Icons
                                            .arrow_forward_ios,
                                        color:
                                        Colors.white38,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}