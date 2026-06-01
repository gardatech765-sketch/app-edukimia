// lib/providers/app_state.dart — FULL FILE (REPLACE SELURUHNYA)

import 'package:flutter/foundation.dart';
import '../core/logger_service.dart';
import '../models/question_model.dart';
import '../models/recap_model.dart';

class AppState extends ChangeNotifier {
  // ✅ BARU: User profile data
  String _nama = '';
  String _kelas = '';
  String _sekolah = '';
  String _selectedAvatar = '🧑‍🔬';
  bool _isProfileSet = false;

  // Progress & evaluation (tidak berubah)
  bool _isMateriSelesai = false;
  bool _isSoalSelesai = false;
  int _skorTotal = 0;
  final List<RecapModel> _rekapEvaluasi = [];

  // ✅ BARU: Getters untuk profile
  String get nama => _nama;
  String get kelas => _kelas;
  String get sekolah => _sekolah;
  String get selectedAvatar => _selectedAvatar;
  bool get isProfileSet => _isProfileSet;

  // Getters lama (tidak berubah)
  bool get isMateriSelesai => _isMateriSelesai;
  bool get isSoalSelesai => _isSoalSelesai;
  int get skorTotal => _skorTotal;
  List<RecapModel> get rekapEvaluasi => List.unmodifiable(_rekapEvaluasi);

  // ✅ BARU: Method simpan data diri
  void saveProfile({
    required String nama,
    required String kelas,
    required String sekolah,
    required String avatar,
  }) {
    _nama = nama.trim();
    _kelas = kelas.trim();
    _sekolah = sekolah.trim();
    _selectedAvatar = avatar;
    _isProfileSet = true;
    logger.i('[AppState] Profile saved — Nama: $_nama, Kelas: $_kelas, Avatar: $_selectedAvatar');
    notifyListeners();
  }

  void markMateriSelesai() {
    _isMateriSelesai = true;
    logger.i('[AppState] Materi marked as read. Latihan Soal is now UNLOCKED.');
    notifyListeners();
  }

  void markSoalSelesai() {
    _isSoalSelesai = true;
    logger.i('[AppState] Quiz completed. Evaluasi is now UNLOCKED.');
    notifyListeners();
  }

  void addWrongAnswer({required QuestionModel question, required int selectedWrongIndex}) {
    final recap = RecapModel(question: question, selectedWrongIndex: selectedWrongIndex);
    _rekapEvaluasi.add(recap);
    logger.d('[AppState] Logged wrong answer for question: "${question.questionText}". '
             'User answered index $selectedWrongIndex, Correct is index ${question.correctIndex}');
    notifyListeners();
  }

  void updateScore(int score) {
    _skorTotal = score;
    logger.i('[AppState] Score updated to: $_skorTotal');
    notifyListeners();
  }

  void resetAll() {
    _isMateriSelesai = false;
    _isSoalSelesai = false;
    _skorTotal = 0;
    _rekapEvaluasi.clear();
    // ✅ BARU: reset profile juga
    _nama = '';
    _kelas = '';
    _sekolah = '';
    _selectedAvatar = '🧑‍🔬';
    _isProfileSet = false;
    logger.i('[AppState] State completely reset.');
    notifyListeners();
  }
}