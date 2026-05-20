import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/adoption_model.dart';
import '../../../../domain/models/user_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../store/adopters_store.dart';

class AdoptersPage extends StatefulWidget {
  const AdoptersPage({super.key});

  @override
  State<AdoptersPage> createState() => _AdoptersPageState();
}

class _AdoptersPageState extends State<AdoptersPage> {
  late final AdoptersStore _store;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<AdoptersStore>();
    _store.start();
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
      appBar: AppDarkTopBar(title: 'Adotantes'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AppSearchBar(
              controller: _searchCtrl,
              hint: 'Pesquisar por nome do pet ou interessado',
              onChanged: _store.setSearchQuery,
            ),
          ),
          Expanded(
            child: Observer(builder: (_) {
              if (_store.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_store.errorMessage != null) {
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
              final groups = _store.groupedAdopters;
              if (groups.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Nenhum interessado nos seus pets ainda.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) => _PetGroupCard(group: groups[i]),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(
        petzinhosRoute: '/favorites',
        centerRoute: '/adopters',
        centerLabel: 'Adotantes',
        centerIcon: Icons.people_outline_rounded,
        categoriesRoute: '/home',
      ),
    );
  }
}

class _PetGroupCard extends StatelessWidget {
  const _PetGroupCard({required this.group});
  final AdoptersGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pets_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.petNome,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${group.adopters.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 4),
          ...group.adopters.map((a) => _AdopterTile(adoption: a)),
        ],
      ),
    );
  }
}

class _AdopterTile extends StatelessWidget {
  const _AdopterTile({required this.adoption});
  final AdoptionModel adoption;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push('/adopter-profile', extra: adoption.adotanteId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            FutureBuilder<UserModel?>(
              future: getIt<UserRepository>().getUserById(adoption.adotanteId),
              builder: (_, snap) => UserAvatar(
                size: 40,
                photoUrl: snap.data?.fotoPerfilUrl,
                fallbackBackground: AppColors.divider,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adoption.adotanteNome.isNotEmpty
                        ? adoption.adotanteNome
                        : 'Interessado',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _statusLabel(adoption.status),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _statusColor(adoption.status),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) => switch (status) {
        'interesse' => 'Aguardando análise',
        'visita_agendada' => 'Visita agendada',
        'adotado' => 'Adoção concluída',
        'cancelado' => 'Recusado',
        _ => status,
      };

  Color _statusColor(String status) => switch (status) {
        'interesse' => AppColors.statusOpen,
        'visita_agendada' => AppColors.accent,
        'adotado' => AppColors.statusAdopted,
        'cancelado' => AppColors.statusCancelled,
        _ => AppColors.textSecondary,
      };
}
