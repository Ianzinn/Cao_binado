import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../presentation/features/auth/store/auth_store.dart';

/// Avatar do usuário **logado** — mostra a foto de perfil ou um ícone
/// genérico como fallback. Reativo ao AuthStore: atualiza quando o
/// usuário altera a foto no perfil.
class CurrentUserAvatar extends StatelessWidget {
  const CurrentUserAvatar({
    super.key,
    this.size = 40,
    this.fallbackColor,
    this.fallbackBackground,
  });

  final double size;
  final Color? fallbackColor;
  final Color? fallbackBackground;

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();
    return Observer(builder: (_) {
      final url = authStore.userProfile?.fotoPerfilUrl;
      return _AvatarShell(
        size: size,
        photoUrl: url,
        fallbackColor: fallbackColor ?? AppColors.textSecondary,
        fallbackBackground: fallbackBackground ?? AppColors.surface,
      );
    });
  }
}

/// Avatar de um usuário arbitrário a partir de URL — fallback pra ícone.
/// Usado pra mostrar foto de outro usuário (ex.: o interessado numa
/// solicitação) sem precisar de Observer.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.photoUrl,
    this.size = 40,
    this.fallbackColor,
    this.fallbackBackground,
  });

  final String? photoUrl;
  final double size;
  final Color? fallbackColor;
  final Color? fallbackBackground;

  @override
  Widget build(BuildContext context) {
    return _AvatarShell(
      size: size,
      photoUrl: photoUrl,
      fallbackColor: fallbackColor ?? AppColors.textSecondary,
      fallbackBackground: fallbackBackground ?? AppColors.surface,
    );
  }
}

class _AvatarShell extends StatelessWidget {
  const _AvatarShell({
    required this.size,
    required this.photoUrl,
    required this.fallbackColor,
    required this.fallbackBackground,
  });

  final double size;
  final String? photoUrl;
  final Color fallbackColor;
  final Color fallbackBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fallbackBackground,
        image: (photoUrl != null && photoUrl!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(photoUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: (photoUrl == null || photoUrl!.isEmpty)
          ? Icon(Icons.person, size: size * 0.55, color: fallbackColor)
          : null,
    );
  }
}
