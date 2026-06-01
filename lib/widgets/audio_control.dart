import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';

/// Central singleton class managing background music and overlapping SFX.
/// Employs robust try-catch blocks to prevent app crashes if files are missing.
class AudioManager {
  static final AudioManager instance = AudioManager._internal();
  factory AudioManager() => instance;
  AudioManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  /// Initializes background music playing in a continuous loop at 30% volume.
  Future<void> initBgm(String bgmPath) async {
    try {
      _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(_isMuted ? 0.0 : 0.3);
      await _bgPlayer.play(AssetSource(bgmPath));
      logger.i('[AudioManager] BGM successfully initialized and playing at 30% volume.');
    } catch (e) {
      logger.w('[AudioManager] Failed to initialize BGM (assets might be missing, running silently): $e');
    }
  }

  /// Mutes or unmutes the background music.
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    try {
      await _bgPlayer.setVolume(_isMuted ? 0.0 : 0.3);
      logger.i('[AudioManager] Global audio mute status changed to: $_isMuted');
    } catch (e) {
      logger.w('[AudioManager] Error adjusting volume: $e');
    }
  }

  /// Plays short sound effects without interrupting the main looping background music.
  /// Dynamically spawns a temporary player that automatically disposes after completion.
  Future<void> playSfx(String sfxPath) async {
    if (_isMuted) return;
    try {
      final sfxPlayer = AudioPlayer();
      await sfxPlayer.setVolume(0.8);
      await sfxPlayer.play(AssetSource(sfxPath));
      
      // Auto-cleanup resource to prevent leaks
      sfxPlayer.onPlayerComplete.listen((event) {
        sfxPlayer.dispose();
      });
      logger.d('[AudioManager] Played SFX: $sfxPath');
    } catch (e) {
      logger.w('[AudioManager] Error playing SFX ($sfxPath): $e');
    }
  }
}

/// Floating glassmorphic button to mute/unmute the audio system.
class AudioControl extends StatefulWidget {
  const AudioControl({super.key});

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  @override
  Widget build(BuildContext context) {
    final audio = AudioManager.instance;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () async {
                await audio.toggleMute();
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  audio.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: AppColors.accentNeon,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
