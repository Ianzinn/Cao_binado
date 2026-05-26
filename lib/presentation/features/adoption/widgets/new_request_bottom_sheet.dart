import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/adoption_model.dart';

class NewRequestBottomSheet extends StatelessWidget {
  const NewRequestBottomSheet({super.key, required this.adoption});

  final AdoptionModel adoption;

  @override
  Widget build(BuildContext context) {
    final isReschedule =
        adoption.status == AdoptionStatusValues.reagendamentoPendente;

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
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isReschedule
                    ? Icons.schedule_rounded
                    : Icons.pets_rounded,
                size: 34,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isReschedule
                ? 'Solicitação de reagendamento'
                : 'Nova solicitação de adoção',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isReschedule
                ? '${adoption.adotanteNome} quer reagendar a visita ao ${adoption.petNome}.'
                : '${adoption.adotanteNome} está interessado em adotar o ${adoption.petNome}.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                'Ver solicitações',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Depois',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
