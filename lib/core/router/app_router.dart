import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../../presentation/features/auth/store/auth_store.dart';
import '../../presentation/features/splash/pages/splash_page.dart';
import '../../presentation/features/splash/pages/onboarding_page.dart';
import '../../presentation/features/auth/pages/login_page.dart';
import '../../presentation/features/auth/pages/register_page.dart';
import '../../presentation/features/home/pages/home_page.dart';
import '../../presentation/features/pets/pages/favorites_page.dart';
import '../../presentation/features/pets/pages/find_page.dart';
import '../../presentation/features/pets/pages/register_animal_page.dart';
import '../../presentation/features/adopters/pages/adopters_page.dart';
import '../../presentation/features/adopters/pages/register_tutor_page.dart';
import '../../presentation/features/history/pages/history_page.dart';
import '../../presentation/features/adoption/pages/adoption_success_page.dart';
import '../../presentation/features/profile/pages/profile_page.dart';

const _publicRoutes = ['/', '/onboarding', '/login', '/register'];
const _adminRoutes = ['/register-animal'];

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh() {
    _sub = FirebaseAuth.instance
        .authStateChanges()
        .listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _AuthRefresh(),
  redirect: (context, state) {
    final auth = getIt<AuthStore>();
    final path = state.uri.path;

    if (!auth.isAuthenticated && !_publicRoutes.contains(path)) {
      return '/';
    }

    if (_adminRoutes.contains(path) && !auth.isAdmin) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (_, __) => const FavoritesPage(),
    ),
    GoRoute(
      path: '/find',
      builder: (_, __) => const FindPage(),
    ),
    GoRoute(
      path: '/register-animal',
      builder: (_, __) => const RegisterAnimalPage(),
    ),
    GoRoute(
      path: '/adopters',
      builder: (_, __) => const AdoptersPage(),
    ),
    GoRoute(
      path: '/register-tutor',
      builder: (_, __) => const RegisterTutorPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (_, __) => const HistoryPage(),
    ),
    GoRoute(
      path: '/adoption-success',
      builder: (context, state) {
        final name = state.extra as String? ?? 'Lilica';
        return AdoptionSuccessPage(petName: name);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (_, __) => const ProfilePage(),
    ),
  ],
);
