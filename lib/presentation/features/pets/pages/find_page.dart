import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/find_store.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  late final FindStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<FindStore>();
    _store.loadPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Encontre seu amigo!'),
      body: Observer(
        builder: (_) {
          if (_store.isLoading && _store.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_store.errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    _store.errorMessage!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          if (_store.pets.isEmpty) {
            return Center(
              child: Text(
                'Nenhum pet disponível no momento.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _store.pets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final pet = _store.pets[i];
              return _FindPetCard(
                pet: pet,
                onAdopt: () async {
                  await _store.adopt(pet);
                  if (context.mounted) {
                    context.go('/adoption-success', extra: pet.nome);
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(
        petzinhosRoute: '/favorites',
        centerRoute: '/home',
        centerLabel: 'Home',
        centerIcon: Icons.home_outlined,
        categoriesRoute: '/adopters',
      ),
    );
  }
}

class _FindPetCard extends StatelessWidget {
  const _FindPetCard({required this.pet, required this.onAdopt});
  final PetModel pet;
  final VoidCallback onAdopt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.card),
              bottomLeft: Radius.circular(AppRadius.card),
            ),
            child: Container(
              width: 130,
              height: 140,
              color: AppColors.surface,
              child: pet.primeiraFotoUrl != null
                  ? Image.network(
                      pet.primeiraFotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.pets_rounded,
                        size: 56,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : const Icon(Icons.pets_rounded,
                      size: 56, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${pet.nome}',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Raça: ${pet.raca}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textPrimary)),
                  Text('Idade: ${pet.idade}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onAdopt,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Adotar',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
