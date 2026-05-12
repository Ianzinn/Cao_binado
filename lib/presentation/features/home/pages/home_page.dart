import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../store/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<HomeStore>();
    _store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Observer(
          builder: (_) => Column(
            children: [
              _TopBar(
                userName: _store.userName,
                onProfileTap: () => context.go('/profile'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _ContributionsCard(
                        date: _store.currentDate,
                        totalDonations: _store.totalDonations,
                        adoptedAnimals: _store.adoptedAnimals,
                      ),
                      const SizedBox(height: 32),
                      _store.isAdmin
                          ? Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    label: 'Cadastrar Animal',
                                    icon: Icons.add_circle_outline_rounded,
                                    onTap: () =>
                                        context.go('/register-animal'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _ActionCard(
                                    label: 'Histórico',
                                    icon: Icons.history_rounded,
                                    onTap: () => context.go('/history'),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    label: 'Favoritos',
                                    icon: Icons.star_border_rounded,
                                    onTap: () => context.go('/favorites'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _ActionCard(
                                    label: 'Encontrar',
                                    icon: Icons.pets_rounded,
                                    onTap: () => context.go('/find'),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(
        petzinhosRoute: '/favorites',
        centerRoute: '/home',
        centerLabel: 'Home',
        centerIcon: Icons.home_outlined,
        categoriesRoute: '/adopters',
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName, required this.onProfileTap});
  final String userName;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Olá, $userName',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: const Icon(Icons.person, size: 30, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionsCard extends StatelessWidget {
  const _ContributionsCard({
    required this.date,
    required this.totalDonations,
    required this.adoptedAnimals,
  });
  final String date;
  final int totalDonations;
  final int adoptedAnimals;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          _StatRow(label: 'Total de doações:', value: totalDonations),
          const SizedBox(height: 4),
          _StatRow(label: 'Animais adotados:', value: adoptedAnimals),
          const SizedBox(height: 10),
          Text(
            'Minhas Contribuições',
            style: GoogleFonts.tomorrow(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.cardNavText,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.89))),
        Text('$value',
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary.withValues(alpha: 0.89))),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const Spacer(),
            Text(
              label,
              style: GoogleFonts.tomorrow(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: AppColors.cardNavText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
