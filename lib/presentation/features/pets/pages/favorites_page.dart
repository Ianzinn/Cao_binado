import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/favorites_store.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final FavoritesStore _store;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<FavoritesStore>();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Favoritos'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AppSearchBar(
              controller: _searchCtrl,
              hint: 'Pesquise por código, descrição, etc...',
              onChanged: _store.setSearchQuery,
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                final list = _store.filtered;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum favorito encontrado.',
                      style: GoogleFonts.poppins(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _PetCard(
                    pet: list[i],
                    onDelete: () => _store.removeFavorite(list[i].id),
                  ),
                );
              },
            ),
          ),
        ],
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

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet, required this.onDelete});
  final PetItem pet;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.card),
              bottomLeft: Radius.circular(AppRadius.card),
            ),
            child: Container(
              width: 90,
              height: 90,
              color: AppColors.divider,
              child: const Icon(Icons.pets_rounded,
                  size: 40, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text('Idade: ${pet.age}',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textPrimary)),
                  Text('Raça: ${pet.breed}',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.statusCancelled, size: 22),
          ),
        ],
      ),
    );
  }
}
