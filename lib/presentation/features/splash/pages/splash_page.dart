import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../auth/store/auth_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _decided = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideRoute());
  }

  Future<void> _decideRoute() async {
    final biometric = getIt<BiometricService>();
    final auth = getIt<AuthStore>();

    // 1ª abertura do app: dispara o consent biométrico do SO (iOS Face ID).
    // Apenas pede a permissão — não ativa o login biométrico.
    await biometric.requestPermissionIfNeeded();

    if (await biometric.isEnabled()) {
      if (mounted) context.go('/login');
      return;
    }
    if (auth.isAuthenticated) {
      if (mounted) context.go('/home');
      return;
    }
    if (mounted) setState(() => _decided = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_decided) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const _CaobinadoTitle(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                'assets/icon/pets.png',
                height: 260,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            Text(
              'Seja bem-vindo!',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _SplashButton(
                label: 'Criar conta',
                onTap: () => context.go('/onboarding'),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _SplashButton(
                label: 'Entrar',
                onTap: () => context.go('/login'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CaobinadoTitle extends StatelessWidget {
  const _CaobinadoTitle();

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Text('Cãobinado', style: titleStyle),
        Positioned(
          top: -12,
          left: MediaQuery.of(context).size.width / 2 + 38,
          child: Transform.rotate(
            angle: -22.15 * math.pi / 180,
            child: Image.asset(
              'assets/icon/paw.png',
              width: 26,
              height: 26,
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashButton extends StatelessWidget {
  const _SplashButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3333),
          borderRadius: BorderRadius.circular(99),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D95ADFE),
              offset: Offset(0, 2),
              blurRadius: 20,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
