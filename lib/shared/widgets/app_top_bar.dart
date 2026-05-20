import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'user_avatar.dart';

class AppDarkTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppDarkTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.showAvatar = true,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showAvatar;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleBack(context),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          if (trailing != null)
            trailing!
          else if (showAvatar)
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: const CurrentUserAvatar(
                size: 41,
                fallbackBackground: Colors.white24,
                fallbackColor: Colors.white,
              ),
            )
          else
            const SizedBox(width: 41),
        ],
      ),
    );
  }
}

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Pesquisar...',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(
            Icons.search_rounded,
            color: AppColors.searchIcon,
            size: 22,
          ),
        ],
      ),
    );
  }
}
