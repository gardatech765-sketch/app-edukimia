import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../models/question_model.dart';
import '../providers/app_state.dart';
import '../widgets/glass_button.dart';
import '../widgets/audio_control.dart';

/// Stateful quiz screen that executes chemical testing questions sequentially.
/// Implements immediate red/green color feedback, custom sfx, and 2-second transitions.
class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  // Convert map arrays into list of models
  final List<QuestionModel> _questions = ChemistryData.quizQuestions
      .map((item) => QuestionModel.fromMap(item))
      .toList();

  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    logger.i('[LatihanScreen] Quiz started. Loading question $_currentIndex.');
  }

  /// Handles user answer selections. Resolves sound effects, haptic profiles,
  /// mistake recap lists, and programs a 2-second advance timer.
  Future<void> _onOptionSelected(int index) async {
    if (_isAnswered) return; // Prevent double taps

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
    });

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = index == currentQuestion.correctIndex;

    if (isCorrect) {
      _correctAnswersCount++;
      logger.i('[LatihanScreen] Correct answer selected at index $index.');
      // Success Audio & Haptics
      AudioManager.instance.playSfx(AppAssets.correctSfx);
      HapticFeedback.mediumImpact();
    } else {
      logger.i(
        '[LatihanScreen] Incorrect answer selected. Chosen $index, Correct is ${currentQuestion.correctIndex}.',
      );
      // Failure Audio, heavy vibration, and record in Evaluation Recap
      AudioManager.instance.playSfx(AppAssets.incorrectSfx);
      HapticFeedback.vibrate();

      Provider.of<AppState>(
        context,
        listen: false,
      ).addWrongAnswer(question: currentQuestion, selectedWrongIndex: index);
    }

    // A 2-second delay to review validation colors, then transition
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _advanceQuiz();
    }
  }

  /// Transitions to the next question or finishes the quiz.
  void _advanceQuiz() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
      logger.i('[LatihanScreen] Loading question $_currentIndex.');
    } else {
      _finishQuiz();
    }
  }

  /// Calculates final score, saves it to AppState, unlocks Evaluation Screen,
  /// and pops back to the dashboard with audio.
  void _finishQuiz() {
    final finalScore = ((_correctAnswersCount / _questions.length) * 100)
        .round();
    logger.i(
      '[LatihanScreen] Quiz complete! Correct count: $_correctAnswersCount / ${_questions.length}. Final score: $finalScore.',
    );

    final state = Provider.of<AppState>(context, listen: false);
    state.updateScore(finalScore);
    state.markSoalSelesai();

    // Trigger tap SFX
    AudioManager.instance.playSfx(AppAssets.tapSfx);

    // Show completion Dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassButton(
          borderColor: AppColors.correctGreen.withValues(alpha: 0.5),
          fillColor: AppColors.correctGreen.withValues(alpha: 0.1),
          paddingVertical: 12,
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.accentNeon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kuis selesai! Skor Anda: $finalScore%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }

  /// Resolves the border color of choice buttons based on validation state.
  Color _resolveOptionBorderColor(int index, int correctIndex) {
    if (!_isAnswered) {
      return Colors.white.withValues(alpha: 0.12);
    }
    // Highlight correct option in teal emerald
    if (index == correctIndex) {
      return AppColors.correctGreen.withValues(alpha: 0.6);
    }
    // Highlight user selection in coral red if incorrect
    if (index == _selectedAnswerIndex) {
      return AppColors.incorrectCoral.withValues(alpha: 0.6);
    }
    return Colors.white.withValues(alpha: 0.04);
  }

  /// Resolves the background fill color of choice buttons based on validation state.
  Color _resolveOptionFillColor(int index, int correctIndex) {
    if (!_isAnswered) {
      return Colors.white.withValues(alpha: 0.02);
    }
    if (index == correctIndex) {
      return AppColors.correctGreen.withValues(alpha: 0.12);
    }
    if (index == _selectedAnswerIndex) {
      return AppColors.incorrectCoral.withValues(alpha: 0.12);
    }
    return Colors.white.withValues(alpha: 0.01);
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.navyStart, AppColors.navyEnd],
              ),
            ),
          ),

          // Glowing background aura
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentNeon.withValues(alpha: 0.02),
              ),
            ),
          ),

          // Core UI Container
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          AudioManager.instance.playSfx(AppAssets.tapSfx);
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'PERTANYAAN ${_currentIndex + 1}/${_questions.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const AudioControl(),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Linear Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      minHeight: 5,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentNeon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Question Area (Glass Card)
                  Expanded(
                    flex: 4,
                    child: GlassButton(
                      borderColor: Colors.white.withValues(alpha: 0.12),
                      fillColor: Colors.white.withValues(alpha: 0.03),
                      paddingVertical: 24,
                      paddingHorizontal: 20,
                      borderRadius: 28,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentNeon.withValues(alpha: 0.05),
                            ),
                            child: const Text(
                              '❓',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            question.questionText,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Colors.white,
                              fontFamily: 'Outfit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Multiple-Choice Options List
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        final optionText = question.options[index];
                        final isCorrect = index == question.correctIndex;
                        final isSelected = index == _selectedAnswerIndex;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GlassButton(
                            onTap: _isAnswered
                                ? null
                                : () => _onOptionSelected(index),
                            borderColor: _resolveOptionBorderColor(
                              index,
                              question.correctIndex,
                            ),
                            fillColor: _resolveOptionFillColor(
                              index,
                              question.correctIndex,
                            ),
                            borderRadius: 20,
                            paddingVertical: 14,
                            child: Row(
                              children: [
                                // Checkmark / Cross status indicators
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isAnswered
                                        ? (isCorrect
                                              ? AppColors.correctGreen
                                                    .withValues(alpha: 0.2)
                                              : (isSelected
                                                    ? AppColors.incorrectCoral
                                                          .withValues(alpha: 0.2)
                                                    : Colors.transparent))
                                        : Colors.white.withValues(alpha: 0.05),
                                    border: Border.all(
                                      color: _isAnswered
                                          ? (isCorrect
                                                ? AppColors.correctGreen
                                                : (isSelected
                                                      ? AppColors.incorrectCoral
                                                      : Colors.white12))
                                          : Colors.white24,
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: _isAnswered
                                      ? (isCorrect
                                            ? const Icon(
                                                Icons.done_rounded,
                                                color: AppColors.correctGreen,
                                                size: 16,
                                              )
                                            : (isSelected
                                                  ? const Icon(
                                                      Icons.close_rounded,
                                                      color: AppColors
                                                          .incorrectCoral,
                                                      size: 16,
                                                    )
                                                  : null))
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          _isAnswered &&
                                              (isCorrect || isSelected)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: _isAnswered
                                          ? (isCorrect
                                                ? AppColors.correctGreen
                                                : (isSelected
                                                      ? AppColors.incorrectCoral
                                                      : Colors.white60))
                                          : Colors.white,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Answer indicator overlay
                  AnimatedOpacity(
                    opacity: _isAnswered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Center(
                        child: Text(
                          _selectedAnswerIndex == question.correctIndex
                              ? '🎉 JAWABAN BENAR!'
                              : '💡 SILAKAN BACA PENJELASAN DI REKAP',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _selectedAnswerIndex == question.correctIndex
                                ? AppColors.correctGreen
                                : AppColors.incorrectCoral,
                            letterSpacing: 1.0,
                            fontFamily: 'Outfit',
                          ),
                        ),
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
}
