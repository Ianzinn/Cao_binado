import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/profile_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<ProfileStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Minha Conta'),
      body: Observer(
        builder: (_) => Column(
          children: [
            const SizedBox(height: 32),

            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _store.isLoading ? null : _store.pickAndUpdatePhoto,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        image: _store.fotoPerfilUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_store.fotoPerfilUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _store.isLoading
                          ? _AvatarLoadingOverlay()
                          : _store.fotoPerfilUrl == null
                              ? const Icon(Icons.person,
                                  size: 72, color: AppColors.textSecondary)
                              : null,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap:
                          _store.isLoading ? null : _store.pickAndUpdatePhoto,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Nome e e-mail do usuário ───────────────────────────────────
            Text(
              _store.userName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _store.userEmail,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            // ── Menu items ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Informações da conta',
                    onTap: () => context.push('/account-info'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  if (!_store.isAdmin) ...[
                    _MenuItem(
                      icon: Icons.volunteer_activism_rounded,
                      label: 'Minhas Adoções',
                      onTap: () => context.push('/my-adoptions'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                  ],
                  _MenuItem(
                    icon: Icons.pets_rounded,
                    label: 'Histórico',
                    onTap: () => context.go('/history'),
                  ),
                  if (_store.biometricSupported) ...[
                    const Divider(height: 1, color: AppColors.divider),
                    _MenuItem(
                      icon: Icons.fingerprint,
                      label: _store.biometricEnabled
                          ? 'Desativar login por biometria'
                          : 'Biometria não ativada',
                      onTap: _store.biometricEnabled
                          ? () async {
                              await _store.disableBiometric();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Login por biometria desativado.'),
                                  ),
                                );
                              }
                            }
                          : () {},
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),

            // ── Botão sair ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: GestureDetector(
                onTap: _store.isLoading
                    ? null
                    : () async {
                        await _store.logout();
                        if (context.mounted) context.go('/');
                      },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.logoutRed,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  alignment: Alignment.center,
                  child: _store.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Sair da Conta',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _store.appVersion,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AvatarLoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black26,
      ),
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
