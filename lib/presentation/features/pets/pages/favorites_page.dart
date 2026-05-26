import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/pet_model.dart';
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
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<FavoritesStore>();
    _store.start();
  }

  void _precacheImages(List<dynamic> list) {
    if (_precached) return;
    _precached = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final pet in list) {
        final url = pet.primeiraFotoUrl as String?;
        if (url != null) {
          precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    });
  }

  @override
  void dispose() {
    _store.dispose();
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
              hint: 'Pesquise por nome do pet',
              onChanged: _store.setSearchQuery,
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                if (_store.isLoading && _store.favorites.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_store.errorMessage != null && _store.favorites.isEmpty) {
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
                final list = _store.filtered;
                if (list.isEmpty) {
                  _precached = false;
                  return Center(
                    child: Text(
                      'Nenhum favorito ainda.',
                      style: GoogleFonts.poppins(color: AppColors.textSecondary),
                    ),
                  );
                }
                _precacheImages(list);
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _FavoriteCard(
                    pet: list[i],
                    onRemove: () => _store.toggleFavorite(list[i].id),
                    onTap: () =>
                        context.push('/pet-details', extra: list[i]),
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

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.pet,
    required this.onRemove,
    required this.onTap,
  });
  final PetModel pet;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
                child: pet.primeiraFotoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: pet.primeiraFotoUrl!,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (_, __) => Shimmer.fromColors(
                          baseColor: AppColors.divider,
                          highlightColor: Colors.white,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.pets_rounded,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : const Icon(Icons.pets_rounded,
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
                    Text(pet.nome,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    if (pet.idade.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text('Idade: ${pet.idade}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.textPrimary)),
                    ],
                    if (pet.raca.isNotEmpty)
                      Text('Raça: ${pet.raca}',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite,
                  color: AppColors.statusCancelled, size: 24),
              tooltip: 'Remover dos favoritos',
            ),
          ],
        ),
      ),
    );
  }
}
