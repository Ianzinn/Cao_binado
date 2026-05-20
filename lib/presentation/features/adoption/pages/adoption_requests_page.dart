import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/models/user_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/adoption_requests_store.dart';
import '../widgets/schedule_visit_bottom_sheet.dart';

class AdoptionRequestsPage extends StatefulWidget {
  const AdoptionRequestsPage({super.key});

  @override
  State<AdoptionRequestsPage> createState() => _AdoptionRequestsPageState();
}

class _AdoptionRequestsPageState extends State<AdoptionRequestsPage> {
  late final AdoptionRequestsStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<AdoptionRequestsStore>();
    _store.start();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  Future<void> _approve(AdoptionModel request) async {
    final result = await showModalBottomSheet<ScheduleVisitResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ScheduleVisitBottomSheet(petNome: request.petNome),
    );
    if (result == null) return;
    if (!mounted) return;
    final ok = await _store.approve(
      request,
      visitLocation: result.location,
      visitDateTime: result.dateTime,
      visitNotes: result.notes,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Visita agendada com ${request.adotanteNome}.'
            : _store.errorMessage ?? 'Não foi possível aprovar.'),
        backgroundColor: ok ? AppColors.accent : Colors.redAccent,
      ),
    );
  }

  Future<void> _reject(AdoptionModel request) async {
    final ok = await _store.reject(request);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Solicitação recusada.'
            : _store.errorMessage ?? 'Não foi possível recusar.'),
        backgroundColor: ok ? AppColors.textSecondary : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Solicitações'),
      body: Observer(builder: (_) {
        if (_store.isLoading && _store.requests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.errorMessage != null && _store.requests.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                _store.errorMessage!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (_store.requests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nenhuma solicitação no momento.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _store.requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final r = _store.requests[i];
            return Observer(
              builder: (_) => _RequestCard(
                request: r,
                isProcessing: _store.isProcessing,
                onApprove: () => _approve(r),
                onReject: () => _reject(r),
                onViewProfile: () =>
                    context.push('/adopter-profile', extra: r.adotanteId),
              ),
            );
          },
        );
      }),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
    required this.onViewProfile,
  });

  final AdoptionModel request;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet info row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: _Avatar(
                  url: request.petFotoUrl,
                  size: 56,
                  fallback: Icons.pets_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.petNome,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Solicitação de adoção',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 14),
          // Adopter section — async fetch
          _AdopterSection(adotanteId: request.adotanteId),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onViewProfile,
            child: Text(
              'Ver perfil completo',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Recusar',
                  onTap: isProcessing ? null : onReject,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PrimaryButton(
                  label: 'Marcar visita',
                  onTap: isProcessing ? null : onApprove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdopterSection extends StatelessWidget {
  const _AdopterSection({required this.adotanteId});
  final String adotanteId;

  @override
  Widget build(BuildContext context) {
    final userRepo = getIt<UserRepository>();
    return FutureBuilder<UserModel?>(
      future: userRepo.getUserById(adotanteId),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 56,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: _Avatar(
                url: user?.fotoPerfilUrl,
                size: 48,
                fallback: Icons.person,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.nome ?? 'Interessado',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (user?.email != null && user!.email.isNotEmpty)
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (user?.telefone != null && user!.telefone!.isNotEmpty)
                    Text(
                      user.telefone!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.url,
    required this.size,
    required this.fallback,
  });

  final String? url;
  final double size;
  final IconData fallback;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() => Container(
        width: size,
        height: size,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: Icon(fallback, color: AppColors.textSecondary, size: size * 0.5),
      );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: onTap == null ? AppColors.textSecondary : AppColors.accent,
          borderRadius: BorderRadius.circular(99),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.divider, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: onTap == null ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
