import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
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
      appBar: AppDarkTopBar(title: 'Adotantes'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AppSearchBar(
              controller: _searchCtrl,
              hint: 'Pesquisar um contato',
              onChanged: _store.setSearchQuery,
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                final list = _store.filtered;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _AdopterCard(
                    adopter: list[i],
                    onDelete: () => _store.removeAdopter(list[i].id),
                  ),
                );
              },
            ),
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

class _AdopterCard extends StatelessWidget {
  const _AdopterCard({required this.adopter, required this.onDelete});
  final AdopterItem adopter;
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
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.divider,
            ),
            child: const Icon(Icons.person, size: 30, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (adopter.name.isNotEmpty)
                    Text(
                      adopter.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  Text(
                    adopter.email,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textPrimary),
                  ),
                  Text(
                    adopter.phone,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.statusCancelled, size: 20),
          ),
        ],
      ),
    );
  }
}
