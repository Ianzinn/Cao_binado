import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/user_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../shared/widgets/app_top_bar.dart';

class AdopterProfilePage extends StatelessWidget {
  const AdopterProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final userRepo = getIt<UserRepository>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Perfil do interessado'),
      body: FutureBuilder<UserModel?>(
        future: userRepo.getUserById(userId),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snap.data;
          if (user == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar o perfil deste usuário.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      image: (user.fotoPerfilUrl != null &&
                              user.fotoPerfilUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(user.fotoPerfilUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (user.fotoPerfilUrl == null ||
                            user.fotoPerfilUrl!.isEmpty)
                        ? const Icon(Icons.person,
                            size: 64, color: AppColors.textSecondary)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    user.nome,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _InfoTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'E-mail',
                  value: user.email,
                ),
                if (user.telefone != null && user.telefone!.isNotEmpty)
                  _InfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Telefone',
                    value: user.telefone!,
                  ),
                _InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Membro desde',
                  value: _formatDate(user.criadoEm),
                ),
                _InfoTile(
                  icon: Icons.badge_outlined,
                  label: 'Tipo de usuário',
                  value: user.tipoUsuario == 'admin'
                      ? 'Administrador'
                      : 'Adotante',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
