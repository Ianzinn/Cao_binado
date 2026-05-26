import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/repositories/adoption_repository.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../adoption/widgets/new_request_bottom_sheet.dart';
import '../../adoption/widgets/visit_scheduled_bottom_sheet.dart';
import '../../auth/store/auth_store.dart';
import '../store/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _store;
  bool _biometricSheetShown = false;
  bool _visitSheetShown = false;
  bool _adminNotifShown = false;
  ReactionDisposer? _adminNotifDisposer;

  @override
  void initState() {
    super.initState();
    _store = getIt<HomeStore>();
    _setupAdminNotification();
    _store.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _maybeOfferBiometric();
      if (mounted) await _maybeShowVisitNotification();
    });
  }

  @override
  void dispose() {
    _adminNotifDisposer?.call();
    super.dispose();
  }

  void _setupAdminNotification() {
    _adminNotifDisposer = autorun((_) {
      final request = _store.newAdminRequest;
      if (request == null || _adminNotifShown || !mounted) return;
      _adminNotifShown = true;
      _store.clearAdminNotification();
      final captured = request;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final goToRequests = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => NewRequestBottomSheet(adoption: captured),
        );
        _adminNotifShown = false;
        if (mounted && goToRequests == true) context.go('/adoption-requests');
      });
    });
  }

  Future<void> _maybeShowVisitNotification() async {
    if (_visitSheetShown) return;
    final auth = getIt<AuthStore>();
    final uid = auth.firebaseUser?.uid;
    if (uid == null) return;
    final repo = getIt<AdoptionRepository>();
    final pending = await repo.findPendingVisitNotification(uid);
    if (pending == null) return;
    if (!mounted) return;
    _visitSheetShown = true;
    debugPrint('📨 Showing VisitScheduledBottomSheet for ${pending.id}');
    final result = await showModalBottomSheet<VisitSheetResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => VisitScheduledBottomSheet(adoption: pending),
    );
    await repo.markVisitNotificationViewed(pending.id);
    if (!mounted) return;
    if (result == VisitSheetResult.reschedule ||
        result == VisitSheetResult.cancel) {
      context.push('/my-adoptions');
    }
  }

  Future<void> _maybeOfferBiometric() async {
    debugPrint('🏠 HomePage._maybeOfferBiometric: alreadyShown=$_biometricSheetShown');
    if (_biometricSheetShown) return;
    final biometric = getIt<BiometricService>();
    final auth = getIt<AuthStore>();
    final pending = auth.pendingBiometricCredentials;
    debugPrint('🏠 pendingBiometricCredentials=${pending != null ? "<set>" : "null"}');
    if (pending == null) return;
    final offer = await biometric.shouldOfferActivation();
    debugPrint('🏠 shouldOfferActivation=$offer');
    if (!offer) return;
    if (!mounted) return;
    _biometricSheetShown = true;
    debugPrint('🏠 Showing biometric BottomSheet');

    final choice = await showModalBottomSheet<_BiometricChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _BiometricBottomSheet(),
    );

    switch (choice) {
      case _BiometricChoice.activate:
        await biometric.enable(pending.email, pending.password);
        auth.clearPendingBiometricCredentials();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login por biometria ativado.')),
          );
        }
      case _BiometricChoice.never:
        await biometric.markNeverAsk();
        auth.clearPendingBiometricCredentials();
      case _BiometricChoice.later:
      case null:
        // Mantém pending: será perguntado novamente no próximo retorno ao home
        // (mesma sessão não pergunta de novo graças ao _biometricSheetShown).
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Observer(
          builder: (_) => Column(
            children: [
              _TopBar(
                userName: _store.userName,
                isAdmin: _store.isAdmin,
                badgeCount: _store.isAdmin
                    ? _store.adminPendingCount
                    : _store.userUnreadCount,
                onProfileTap: () => context.go('/profile'),
                onNotificationTap: () => _store.isAdmin
                    ? context.go('/adoption-requests')
                    : context.push('/my-adoptions'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _ContributionsCard(
                        date: _store.currentDate,
                        totalDonations: _store.totalDonations,
                        adoptedAnimals: _store.adoptedAnimals,
                      ),
                      const SizedBox(height: 32),
                      _store.isAdmin
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Cadastrar Animal',
                                        icon:
                                            Icons.add_circle_outline_rounded,
                                        onTap: () =>
                                            context.go('/register-animal'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Solicitações',
                                        icon: Icons.mail_outline_rounded,
                                        onTap: () =>
                                            context.go('/adoption-requests'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Histórico',
                                        icon: Icons.history_rounded,
                                        onTap: () => context.go('/history'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(child: SizedBox.shrink()),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Favoritos',
                                        icon: Icons.star_border_rounded,
                                        onTap: () => context.go('/favorites'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Encontrar',
                                        icon: Icons.pets_rounded,
                                        onTap: () => context.go('/find'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionCard(
                                        label: 'Minhas Adoções',
                                        icon: Icons.volunteer_activism_rounded,
                                        onTap: () =>
                                            context.go('/my-adoptions'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(child: SizedBox.shrink()),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.userName,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.badgeCount,
    required this.isAdmin,
  });
  final String userName;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final int badgeCount;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Olá, $userName',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Ícone de notificação com badge
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isAdmin
                      ? Icons.mail_outline_rounded
                      : Icons.notifications_none_rounded,
                  size: 28,
                  color: AppColors.textPrimary,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.statusCancelled,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: onProfileTap,
            child: const CurrentUserAvatar(size: 48),
          ),
        ],
      ),
    );
  }
}

class _ContributionsCard extends StatelessWidget {
  const _ContributionsCard({
    required this.date,
    required this.totalDonations,
    required this.adoptedAnimals,
  });
  final String date;
  final int totalDonations;
  final int adoptedAnimals;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          _StatRow(label: 'Total de doações:', value: totalDonations),
          const SizedBox(height: 4),
          _StatRow(label: 'Animais adotados:', value: adoptedAnimals),
          const SizedBox(height: 10),
          Text(
            'Minhas Contribuições',
            style: GoogleFonts.tomorrow(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.cardNavText,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary.withValues(alpha: 0.89))),
        Text('$value',
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary.withValues(alpha: 0.89))),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const Spacer(),
            Text(
              label,
              style: GoogleFonts.tomorrow(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: AppColors.cardNavText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _BiometricChoice { activate, later, never }

class _BiometricBottomSheet extends StatelessWidget {
  const _BiometricBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Icon(Icons.fingerprint, size: 56, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            'Deseja ativar login por biometria?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Da próxima vez, você pode entrar usando a biometria do seu dispositivo, sem precisar digitar a senha.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _SheetButton(
            label: 'Ativar biometria',
            isPrimary: true,
            onTap: () =>
                Navigator.of(context).pop(_BiometricChoice.activate),
          ),
          const SizedBox(height: 12),
          _SheetButton(
            label: 'Agora não',
            onTap: () => Navigator.of(context).pop(_BiometricChoice.later),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_BiometricChoice.never),
            child: Text(
              'Não perguntar mais',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.primary, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
