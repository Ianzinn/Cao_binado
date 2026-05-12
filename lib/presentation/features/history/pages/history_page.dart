import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/history_store.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryStore _store;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<HistoryStore>();
    _store.loadHistory();
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
      appBar: AppDarkTopBar(title: 'Histórico'),
      body: Observer(
        builder: (_) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: AppSearchBar(
                controller: _searchCtrl,
                hint: 'Pesquisar...',
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _store.records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _HistoryCard(record: _store.records[i]),
              ),
            ),
            _SummaryBar(
              inProgress: _store.inProgressCount,
              completed: _store.completedCount,
            ),
          ],
        ),
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

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});
  final AdoptionRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.petName,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Adotante: ${record.adopterName}',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.textPrimary)),
              _StatusBadge(status: record.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final AdoptionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      AdoptionStatus.adopted => ('Adotado', AppColors.statusAdopted),
      AdoptionStatus.cancelled => ('Cancelado', AppColors.statusCancelled),
      AdoptionStatus.open => ('Em Aberto', AppColors.statusOpen),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.inProgress, required this.completed});
  final int inProgress;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(children: [
                  Text('Em andamento',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('$inProgress',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ]),
              ),
            ),
            const VerticalDivider(
                thickness: 1,
                color: AppColors.divider,
                indent: 10,
                endIndent: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(children: [
                  Text('Concluídas',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('$completed',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
