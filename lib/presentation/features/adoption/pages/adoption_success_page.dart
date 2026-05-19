import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/pet_model.dart';

class AdoptionSuccessPage extends StatelessWidget {
  const AdoptionSuccessPage({super.key, this.pet});

  final PetModel? pet;

  @override
  Widget build(BuildContext context) {
    final petName = pet?.nome ?? 'seu novo amigo';
    final photoUrl = pet?.primeiraFotoUrl;

    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    'Adoção Confirmada',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 41,
                    height: 41,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Você adotou o $petName com sucesso!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white24,
                    child: photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              );
                            },
                            errorBuilder: (_, __, ___) => const _PetFallback(),
                          )
                        : const _PetFallback(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              petName,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: () => context.go('/home'),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    boxShadow: AppShadows.primaryButton,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Voltar para a Home',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PetFallback extends StatelessWidget {
  const _PetFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.pets_rounded, size: 120, color: Colors.white),
    );
  }
}
