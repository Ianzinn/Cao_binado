import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Cãobinado',
      subtitle: 'Seu novo melhor amigo!',
      description:
          'Conectando lares e transformando vidas.\nFacilitando a adoção de animais de forma rápida e segura amor e cuidado na palma da sua mão.',
    ),
    _OnboardingData(
      title: 'Encontre seu amigo',
      subtitle: 'Adote com amor',
      description:
          'Encontre o pet ideal para a sua família. Filhotes, adultos, cães, gatos e muito mais esperando por você.',
    ),
    _OnboardingData(
      title: 'Doe com carinho',
      subtitle: 'Transforme uma vida',
      description:
          'Cadastre animais para adoção e ajude a encontrar um lar cheio de amor para eles.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      context.go('/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page.subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                page.description,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage
                          ? AppColors.primary
                          : AppColors.textPlaceholder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _next,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.buttonSocial),
                    boxShadow: AppShadows.primaryButton,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Próximo' : 'Começar',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(AppRadius.buttonSocial),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Pular',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
  });
  final String title;
  final String subtitle;
  final String description;
}
