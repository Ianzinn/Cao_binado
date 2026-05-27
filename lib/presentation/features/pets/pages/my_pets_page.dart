import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/pet_model.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/my_pets_store.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  late final MyPetsStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MyPetsStore>();
    _store.start();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(PetModel pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(
          'Remover pet?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Tem certeza que deseja remover ${pet.nome}? Esta ação não pode ser desfeita.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Remover',
              style: GoogleFonts.poppins(
                color: AppColors.statusCancelled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final ok = await _store.deletePet(pet.id);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_store.errorMessage ?? 'Erro ao remover pet.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Meus Pets'),
      body: Observer(
        builder: (_) {
          if (_store.isLoading && _store.pets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_store.pets.isEmpty) {
            return Center(
              child: Text(
                'Nenhum pet cadastrado ainda.',
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
              return _MyPetCard(
                pet: pet,
                onEdit: () => context.push('/edit-animal', extra: pet),
                onDelete: () => _confirmDelete(pet),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyPetCard extends StatelessWidget {
  const _MyPetCard({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  final PetModel pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
            child: SizedBox(
              width: 90,
              height: 90,
              child: pet.primeiraFotoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: pet.primeiraFotoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surface),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.pets_rounded,
                            size: 36, color: AppColors.textSecondary),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.pets_rounded,
                          size: 36, color: AppColors.textSecondary),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.nome,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${pet.especie} · ${pet.porte}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                color: AppColors.primary,
                tooltip: 'Editar',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.statusCancelled,
                tooltip: 'Remover',
              ),
              const SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
