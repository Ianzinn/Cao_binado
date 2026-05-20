import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/pet_model.dart';
import '../store/favorites_store.dart';
import '../store/find_store.dart';

class PetDetailsPage extends StatefulWidget {
  const PetDetailsPage({super.key, required this.pet});

  final PetModel pet;

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  late final PageController _pageController;
  late final FindStore _findStore;
  late final FavoritesStore _favoritesStore;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _findStore = getIt<FindStore>();
    _favoritesStore = getIt<FavoritesStore>();
    _favoritesStore.start();
  }

  @override
  void dispose() {
    _favoritesStore.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleAdopt() async {
    final pet = widget.pet;
    final result = await _findStore.requestAdoption(pet);
    if (!mounted) return;
    switch (result) {
      case RequestAdoptionResult.success:
        context.go('/adoption-success', extra: pet);
      case RequestAdoptionResult.duplicate:
      case RequestAdoptionResult.notLogged:
      case RequestAdoptionResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _findStore.adoptErrorMessage ??
                  'Não foi possível enviar a solicitação.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/find');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final isAdopted = pet.status == PetStatus.adotado;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Gallery(
            pet: pet,
            controller: _pageController,
            currentPage: _currentPage,
            onPageChanged: (i) => setState(() => _currentPage = i),
            onBack: _back,
            favoritesStore: _favoritesStore,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          pet.nome,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _StatusPill(isAdopted: isAdopted),
                    ],
                  ),
                  if (pet.raca.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      pet.raca,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _InfoChips(pet: pet),
                  const SizedBox(height: 28),
                  _SectionTitle('Sobre'),
                  const SizedBox(height: 8),
                  Text(
                    pet.descricao.isNotEmpty
                        ? pet.descricao
                        : 'Sem descrição cadastrada.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Observer(builder: (_) {
            final disabled = isAdopted || _findStore.isAdopting;
            return GestureDetector(
              onTap: disabled ? null : _handleAdopt,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56,
                decoration: BoxDecoration(
                  color: isAdopted
                      ? AppColors.textSecondary
                      : AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  boxShadow: disabled ? null : AppShadows.primaryButton,
                ),
                alignment: Alignment.center,
                child: _findStore.isAdopting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        isAdopted ? 'Adotado' : 'Solicitar adoção',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.pet,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
    required this.onBack,
    required this.favoritesStore,
  });

  final PetModel pet;
  final PageController controller;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onBack;
  final FavoritesStore favoritesStore;

  @override
  Widget build(BuildContext context) {
    final photos = pet.fotosUrls;
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          Positioned.fill(
            child: photos.isEmpty
                ? Hero(tag: pet.id, child: const _NoPhotoPlaceholder())
                : PageView.builder(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    itemCount: photos.length,
                    itemBuilder: (_, i) {
                      final image = Image.network(
                        photos[i],
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) =>
                            const _NoPhotoPlaceholder(),
                      );
                      // Hero apenas na primeira foto (a que aparece no card).
                      return i == 0
                          ? Hero(tag: pet.id, child: image)
                          : image;
                    },
                  ),
          ),
          // Gradiente sutil pra contraste do botão voltar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Botão voltar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),
          ),
          // Botão favoritar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Observer(builder: (_) {
              final isFav = favoritesStore.isFavorited(pet.id);
              return GestureDetector(
                onTap: () => favoritesStore.toggleFavorite(pet.id),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border_rounded,
                    color: isFav
                        ? AppColors.statusCancelled
                        : AppColors.primary,
                    size: 22,
                  ),
                ),
              );
            }),
          ),
          // Indicadores de página
          if (photos.length > 1)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (i) {
                  final active = i == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoPhotoPlaceholder extends StatelessWidget {
  const _NoPhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.pets_rounded,
        size: 96,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isAdopted});
  final bool isAdopted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAdopted ? AppColors.statusAdopted : AppColors.statusOpen,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isAdopted ? 'Adotado' : 'Disponível',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _InfoChips extends StatelessWidget {
  const _InfoChips({required this.pet});
  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    final entries = <_ChipEntry>[
      if (pet.especie.isNotEmpty)
        _ChipEntry(
          icon: Icons.category_outlined,
          label: _humanizeEspecie(pet.especie),
        ),
      if (pet.idade.isNotEmpty)
        _ChipEntry(icon: Icons.cake_outlined, label: pet.idade),
      if (pet.porte.isNotEmpty)
        _ChipEntry(icon: Icons.straighten_outlined, label: pet.porte),
    ];
    if (entries.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: entries
          .map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(e.icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      e.label,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _ChipEntry {
  const _ChipEntry({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

String _humanizeEspecie(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'mammalia':
    case 'mamífero':
    case 'mamifero':
      return 'Mamífero';
    case 'aves':
    case 'ave':
      return 'Ave';
    case 'reptilia':
    case 'réptil':
    case 'reptil':
      return 'Réptil';
    case 'animalia':
    case 'animal':
      return 'Animal';
    case 'plantae':
    case 'planta':
      return 'Planta';
    default:
      if (raw.isEmpty) return raw;
      return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
  }
}
