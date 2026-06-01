import 'package:flutter/foundation.dart';
import '../core/logger_service.dart';
import '../models/question_model.dart';
import '../models/recap_model.dart';

/// AppState manages the entire in-memory global state of the Chemistry game.
/// Tracks learning progression, quiz completion, final evaluation score,
/// and stores errors dynamically using a strongly-typed RecapModel.
class AppState extends ChangeNotifier {
  // Global progress & evaluation variables
  bool _isMateriSelesai = false;
  bool _isSoalSelesai = false;
  int _skorTotal = 0;
  final List<RecapModel> _rekapEvaluasi = [];

  // Getters for secure read-only access from UI
  bool get isMateriSelesai => _isMateriSelesai;
  bool get isSoalSelesai => _isSoalSelesai;
  int get skorTotal => _skorTotal;
  List<RecapModel> get rekapEvaluasi => List.unmodifiable(_rekapEvaluasi);

  /// Unlocks the Latihan Soal (Quiz) screen after reading chemistry material.
  void markMateriSelesai() {
    _isMateriSelesai = true;
    logger.i('[AppState] Materi marked as read. Latihan Soal is now UNLOCKED.');
    notifyListeners();
  }

  /// Unlocks the Evaluasi screen after finishing all questions.
  void markSoalSelesai() {
    _isSoalSelesai = true;
    logger.i('[AppState] Quiz completed. Evaluasi is now UNLOCKED.');
    notifyListeners();
  }

  /// Appends an incorrect answer log during the quiz.
  void addWrongAnswer({required QuestionModel question, required int selectedWrongIndex}) {
    final recap = RecapModel(
      question: question,
      selectedWrongIndex: selectedWrongIndex,
    );
    _rekapEvaluasi.add(recap);
    logger.d('[AppState] Logged wrong answer for question: "${question.questionText}". '
             'User answered index $selectedWrongIndex, Correct is index ${question.correctIndex}');
    notifyListeners();
  }

  /// Updates the final score after completing the exercise.
  void updateScore(int score) {
    _skorTotal = score;
    logger.i('[AppState] Score updated to: $_skorTotal');
    notifyListeners();
  }

  /// Completely resets all states back to default (locked/empty).
  void resetAll() {
    _isMateriSelesai = false;
    _isSoalSelesai = false;
    _skorTotal = 0;
    _rekapEvaluasi.clear();
    logger.i('[AppState] State completely reset. Resetting progression locks and recap history.');
    notifyListeners();
  }
}
