import 'package:admin_panel/features/profile/presentation/widgets/lock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Fullscreen lock screen.
/// Old overlay (LockOverlay) orqada AppShell'ni ko'rsatib qo'yardi.
/// Bu sahifa esa butun ekranni egallaydi — ma'lumotlar ko'rinmaydi.
class LockScreen extends StatefulWidget {
  final LockController lock;
  const LockScreen({super.key, required this.lock});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _errorText;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // back bilan chiqib ketmasin
      child: Scaffold(
        body: Row(
          children: [
            // LEFT BLUE PANEL
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0B76FF),
                      Color(0xFF0A4EE6),
                      Color(0xFF063BBE),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 80.w, right: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/logo/logo.svg',
                          width: 140.w,
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Ombor va savdo boshqaruv tizimi',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // RIGHT WHITE PANEL
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 520.w),
                    child: AnimatedBuilder(
                      animation: widget.lock,
                      builder: (context, _) {
                        return FutureBuilder<DateTime?>(
                          future: widget.lock.lockedUntil(),
                          builder: (context, snap) {
                            final until = snap.data;
                            final locked = until != null;

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tizimga kirish',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    locked
                                        ? "Ko‘p xato kiritildi. Qayta urinish: ${_fmtTime(until)}"
                                        : 'Davom etish uchun parolni kiriting',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 26.h),

                                  _PasswordField(
                                    controller: _passCtrl,
                                    enabled: !locked && !_busy,
                                    obscure: _obscure,
                                    errorText: _errorText,
                                    onToggle: () => setState(() => _obscure = !_obscure),
                                    onSubmitted: () => _tryUnlock(locked),
                                  ),

                                  SizedBox(height: 18.h),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 48.h,
                                    child: ElevatedButton(
                                      onPressed:
                                      locked || _busy ? null : () => _tryUnlock(false),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0B76FF),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28.r),
                                        ),
                                      ),
                                      child: _busy
                                          ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                          : Text(
                                        'Kirish',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return '-';
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '${dt.hour}:$m:$s';
  }

  Future<void> _tryUnlock(bool locked) async {
    if (locked) return;

    final pass = _passCtrl.text.trim();
    if (pass.isEmpty) {
      setState(() => _errorText = 'Parolni kiriting');
      return;
    }

    setState(() {
      _busy = true;
      _errorText = null;
    });

    final ok = await widget.lock.unlockWithPassword(pass);

    setState(() => _busy = false);

    if (!ok) {
      setState(() => _errorText = 'Parol noto‘g‘ri');
    } else {
      _passCtrl.clear();
      setState(() => _errorText = null);
    }
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool obscure;
  final String? errorText;
  final VoidCallback onToggle;
  final VoidCallback onSubmitted;

  const _PasswordField({
    required this.controller,
    required this.enabled,
    required this.obscure,
    required this.errorText,
    required this.onToggle,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.r),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    );

    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: 'Parolni kiriting',
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        suffixIcon: IconButton(
          onPressed: enabled ? onToggle : null,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: Color(0xFF0B76FF), width: 1.2),
        ),
      ),
      onSubmitted: (_) => onSubmitted(),
    );
  }
}
