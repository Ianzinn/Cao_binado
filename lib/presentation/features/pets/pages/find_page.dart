import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/di/injection.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/favorites_store.dart';
import '../store/find_store.dart';
import '../widgets/pet_filters_bottom_sheet.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  late final FindStore _store;
  late final FavoritesStore _favorites;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<FindStore>();
    _favorites = getIt<FavoritesStore>();
    _store.loadPets();
    _favorites.start();
  }

  @override
  void dispose() {
    _favorites.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<(String?, String?)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PetFiltersBottomSheet(
        initialEspecie: _store.especieFilter,
        initialPorte: _store.porteFilter,
      ),
    );
    if (result == null) return;
    final (especie, porte) = result;
    _store.applyFilters(especie, porte);
  }

  void _precacheImages() {
    if (_precached) return;
    _precached = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final pet in _store.pets) {
        final url = pet.primeiraFotoUrl;
        if (url != null) {
          precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Encontre seu amigo!'),
      body: Observer(
        builder: (_) {
          final filterCount = _store.activeFilterCount;

          Widget content;
          if (_store.isLoading && _store.pets.isEmpty) {
            content = const Center(child: CircularProgressIndicator());
          } else if (_store.errorMessage != null) {
            content = Padding(
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
          } else if (_store.pets.isEmpty) {
            _precached = false;
            content = Center(
              child: Text(
                filterCount > 0
                    ? 'Nenhum pet encontrado para os filtros selecionados.'
                    : 'Nenhum pet disponível no momento.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            _precacheImages();
            content = ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _store.pets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final pet = _store.pets[i];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push('/pet-details', extra: pet),
                  child: _FindPetCard(
                    pet: pet,
                    isAdopting: _store.isAdopting,
                    favoritesStore: _favorites,
                    onAdopt: () async {
                      final result = await _store.requestAdoption(pet);
                      if (!context.mounted) return;
                      switch (result) {
                        case RequestAdoptionResult.success:
                          context.go('/adoption-success', extra: pet);
                        case RequestAdoptionResult.duplicate:
                        case RequestAdoptionResult.notLogged:
                        case RequestAdoptionResult.error:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _store.adoptErrorMessage ??
                                    'Não foi possível enviar a solicitação.',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                      }
                    },
                  ),
                );
              },
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: GestureDetector(
                  onTap: _openFilters,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: filterCount > 0
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: filterCount > 0
                            ? AppColors.primary
                            : AppColors.divider,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: filterCount > 0
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filterCount > 0
                              ? 'Filtros ($filterCount)'
                              : 'Filtros',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: filterCount > 0
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: content),
            ],
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
  const _FindPetCard({
    required this.pet,
    required this.onAdopt,
    required this.isAdopting,
    required this.favoritesStore,
  });
  final PetModel pet;
  final VoidCallback onAdopt;
  final bool isAdopting;
  final FavoritesStore favoritesStore;

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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.card),
                  bottomLeft: Radius.circular(AppRadius.card),
                ),
                child: Hero(
                  tag: pet.id,
                  child: Container(
                    width: 130,
                    height: 140,
                    color: AppColors.surface,
                    child: pet.primeiraFotoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: pet.primeiraFotoUrl!,
                            fit: BoxFit.cover,
                            fadeInDuration:
                                const Duration(milliseconds: 200),
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: AppColors.surface,
                              highlightColor: Colors.white,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.pets_rounded,
                              size: 56,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : const Icon(Icons.pets_rounded,
                            size: 56, color: AppColors.textSecondary),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Observer(
                  builder: (_) {
                    final isFav = favoritesStore.isFavorited(pet.id);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => favoritesStore.toggleFavorite(pet.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFav
                              ? AppColors.statusCancelled
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
                      onTap: isAdopting ? null : onAdopt,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: isAdopting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Solicitar',
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
