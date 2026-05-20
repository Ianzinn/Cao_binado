import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/adoption_model.dart';

class VisitScheduledBottomSheet extends StatelessWidget {
  const VisitScheduledBottomSheet({super.key, required this.adoption});

  final AdoptionModel adoption;

  @override
  Widget build(BuildContext context) {
    final dt = adoption.visitaData;
    final dateStr = dt != null ? _formatDate(dt) : '—';
    final timeStr = dt != null ? _formatTime(dt) : '—';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Icon(Icons.pets_rounded,
                size: 56, color: AppColors.accent),
          ),
          const SizedBox(height: 12),
          Text(
            'Visita agendada',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Seu pedido de adoção foi aprovado! Anota aí os detalhes da visita.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          _InfoRow(icon: Icons.pets_outlined, label: 'Pet', value: adoption.petNome),
          if (adoption.visitLocation != null)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Local',
              value: adoption.visitLocation!,
            ),
          _InfoRow(icon: Icons.calendar_today_outlined, label: 'Data', value: dateStr),
          _InfoRow(icon: Icons.access_time, label: 'Horário', value: timeStr),
          if (adoption.visitNotes != null && adoption.visitNotes!.isNotEmpty)
            _InfoRow(
              icon: Icons.notes_outlined,
              label: 'Observações',
              value: adoption.visitNotes!,
            ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                'Entendi',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
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
