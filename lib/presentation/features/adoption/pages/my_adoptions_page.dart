import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/my_adoptions_store.dart';
import '../widgets/cancel_adoption_bottom_sheet.dart';
import '../widgets/reschedule_visit_bottom_sheet.dart';

class MyAdoptionsPage extends StatefulWidget {
  const MyAdoptionsPage({super.key});

  @override
  State<MyAdoptionsPage> createState() => _MyAdoptionsPageState();
}

class _MyAdoptionsPageState extends State<MyAdoptionsPage> {
  late final MyAdoptionsStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MyAdoptionsStore>();
    _store.start();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  Future<void> _requestReschedule(AdoptionModel adoption) async {
    final result = await showModalBottomSheet<RescheduleVisitResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => RescheduleVisitBottomSheet(
        petNome: adoption.petNome,
        currentVisitaData: adoption.visitaData,
      ),
    );
    if (result == null) return;
    if (!mounted) return;
    final ok = await _store.requestReschedule(
      adoption,
      newDateTime: result.newDateTime,
      reason: result.reason,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Reagendamento solicitado. Aguarde confirmação do protetor.'
            : _store.errorMessage ?? 'Não foi possível solicitar o reagendamento.'),
        backgroundColor: ok ? AppColors.accent : Colors.redAccent,
      ),
    );
  }

  Future<void> _cancelAdoption(AdoptionModel adoption) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CancelAdoptionBottomSheet(petNome: adoption.petNome),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    final ok = await _store.cancelAdoption(adoption);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Solicitação cancelada.'
            : _store.errorMessage ?? 'Não foi possível cancelar.'),
        backgroundColor: ok ? AppColors.textSecondary : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Minhas Adoções'),
      body: Observer(builder: (_) {
        if (_store.isLoading && _store.adoptions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.errorMessage != null && _store.adoptions.isEmpty) {
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
        if (_store.adoptions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets_rounded,
                      size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma solicitação ativa.',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _store.adoptions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final adoption = _store.adoptions[i];
            return Observer(
              builder: (_) => _AdoptionCard(
                adoption: adoption,
                isProcessing: _store.isProcessing,
                onReschedule: adoption.status ==
                        AdoptionStatusValues.reagendamentoPendente
                    ? null
                    : () => _requestReschedule(adoption),
                onCancel: () => _cancelAdoption(adoption),
              ),
            );
          },
        );
      }),
    );
  }
}

class _AdoptionCard extends StatelessWidget {
  const _AdoptionCard({
    required this.adoption,
    required this.isProcessing,
    required this.onReschedule,
    required this.onCancel,
  });

  final AdoptionModel adoption;
  final bool isProcessing;
  final VoidCallback? onReschedule;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isReschedulePending =
        adoption.status == AdoptionStatusValues.reagendamentoPendente;
    final hasVisit = adoption.visitaData != null;

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
          // Pet info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: _PetAvatar(url: adoption.petFotoUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adoption.petNome,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: adoption.status),
                  ],
                ),
              ),
            ],
          ),

          // Visit info
          if (hasVisit) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: _formatVisit(adoption.visitaData!),
            ),
            if (adoption.visitLocation != null) ...[
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: adoption.visitLocation!,
              ),
            ],
          ],

          // Reschedule pending notice
          if (isReschedulePending && adoption.rescheduleData != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.statusOpen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 16, color: AppColors.statusOpen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nova data proposta: ${_formatVisit(adoption.rescheduleData!)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.statusOpen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Cancelar',
                  color: AppColors.statusCancelled,
                  onTap: isProcessing ? null : onCancel,
                ),
              ),
              if (hasVisit) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _PrimaryButton(
                    label: isReschedulePending
                        ? 'Aguardando...'
                        : 'Reagendar',
                    onTap: isProcessing ? null : onReschedule,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatVisit(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$date às $time';
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url!,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.surface,
          highlightColor: Colors.white,
          child: Container(width: 56, height: 56, color: Colors.white),
        ),
        errorWidget: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() => Container(
        width: 56,
        height: 56,
        color: AppColors.surface,
        alignment: Alignment.center,
        child: const Icon(Icons.pets_rounded,
            color: AppColors.textSecondary, size: 28),
      );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      AdoptionStatusValues.visitaAgendada => ('Visita agendada', AppColors.statusOpen),
      AdoptionStatusValues.reagendamentoPendente => ('Reagendamento pendente', Colors.orange),
      _ => ('Aguardando', AppColors.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
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
  const _SecondaryButton({
    required this.label,
    required this.onTap,
    this.color,
  });
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: onTap == null ? AppColors.divider : foreground,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: onTap == null ? AppColors.textSecondary : foreground,
          ),
        ),
      ),
    );
  }
}
