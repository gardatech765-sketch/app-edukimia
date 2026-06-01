// ✅ FILE BARU: lib/screens/form_data_diri_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../providers/app_state.dart';
import '../widgets/glass_button.dart';

class FormDataDiriScreen extends StatefulWidget {
  const FormDataDiriScreen({super.key});

  @override
  State<FormDataDiriScreen> createState() => _FormDataDiriScreenState();
}

class _FormDataDiriScreenState extends State<FormDataDiriScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _sekolahController = TextEditingController();

  String _selectedAvatar = '🧑‍🔬';
  static const _avatars = ['🧑‍🔬', '👩‍🔬', '🦸', '🧙'];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    logger.i('[FormDataDiriScreen] Initialized.');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    _sekolahController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.saveProfile(
        nama: _namaController.text,
        kelas: _kelasController.text,
        sekolah: _sekolahController.text,
        avatar: _selectedAvatar,
      );
      logger.i('[FormDataDiriScreen] Profile saved. Navigating to MenuScreen.');
      Navigator.pushReplacementNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyStart, AppColors.navyEnd],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 32.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Judul di paling atas
                      const Text(
                        'Data Diri',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentNeon,
                          letterSpacing: 1.5,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Isi data kamu sebelum mulai belajar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                          fontFamily: 'Outfit',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // Avatar picker
                      const Text(
                        'Pilih Avatar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentNeon,
                          letterSpacing: 0.8,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _avatars.map((avatar) {
                          final isSelected = _selectedAvatar == avatar;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedAvatar = avatar),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: isSelected ? 72 : 58,
                              height: isSelected ? 72 : 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.accentNeon.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.05),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentNeon
                                      : Colors.white.withValues(alpha: 0.12),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.accentNeon.withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                avatar,
                                style: TextStyle(fontSize: isSelected ? 34 : 26),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
                      _buildField(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person_rounded,
                        hint: 'Masukkan nama lengkap kamu',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        controller: _kelasController,
                        label: 'Kelas',
                        icon: Icons.class_rounded,
                        hint: 'Contoh: XI IPA 2',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Kelas tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        controller: _sekolahController,
                        label: 'Asal Sekolah',
                        icon: Icons.school_rounded,
                        hint: 'Contoh: SMAN 1 Jakarta',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Nama sekolah tidak boleh kosong'
                                : null,
                      ),
                      const SizedBox(height: 40),
                      GlassButton(
                        onTap: _submit,
                        borderColor: AppColors.accentNeon.withValues(alpha: 0.5),
                        fillColor: AppColors.accentNeon.withValues(alpha: 0.12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.accentNeon,
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'MULAI BELAJAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentNeon,
                                letterSpacing: 1.5,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accentNeon,
            letterSpacing: 0.8,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Outfit',
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white24,
              fontFamily: 'Outfit',
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.accentNeon, size: 20),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentNeon, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.incorrectCoral),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.incorrectCoral, width: 1.5),
            ),
            errorStyle: const TextStyle(
              color: AppColors.incorrectCoral,
              fontFamily: 'Outfit',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}