import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../presentation/features/auth/store/auth_store.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    this.petzinhosRoute = '/favorites',
    this.centerRoute = '/home',
    this.categoriesRoute = '/adopters',
    this.centerLabel = 'Home',
    this.centerIcon = Icons.home_outlined,
  });

  final String petzinhosRoute;
  final String centerRoute;
  final String categoriesRoute;
  final String centerLabel;
  final IconData centerIcon;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final authStore = getIt<AuthStore>();

    final isCenter = location == centerRoute || location.startsWith(centerRoute);
    final isPetzinhos = location == petzinhosRoute || location.startsWith(petzinhosRoute);

    return Observer(builder: (_) {
      final showCategories = authStore.isAdmin;
      final isCategories = showCategories && !isPetzinhos && !isCenter;

      return Container(
        margin: const EdgeInsets.fromLTRB(6, 0, 6, 8),
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.pets_rounded,
              label: 'Petzinhos',
              selected: isPetzinhos,
              onTap: () => context.go(petzinhosRoute),
            ),
            _NavItem(
              icon: centerIcon,
              label: centerLabel,
              selected: isCenter,
              onTap: () => context.go(centerRoute),
            ),
            if (showCategories)
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Adotantes',
                selected: isCategories,
                onTap: () => context.go(categoriesRoute),
              ),
          ],
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.primary
        : AppColors.textPrimary.withValues(alpha: 0.86);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
