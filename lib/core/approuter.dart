// lib/app_router.dart

// import 'package:escrow/features/onboarding/presentation/onboarding_screen.dart';
// import 'package:escrow/features/home/presentation/home_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/profileComplete.dart';

import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/verifyOtp.dart';
import '../features/dashboard/presentation/pages/dashboard.dart';
import '../features/dashboard/presentation/pages/main_nav.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/transactions/presentation/pages/join_transaction_page.dart';
import '../features/transactions/presentation/pages/new_transaction_page.dart';
import '../screens/onboarding_screen.dart';
import 'pageTransition.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    observers: [FlutterSmartDialog.observer],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      final token = prefs.getString('jwt_token');
      final loc = state.matchedLocation;

      // 1. If onboarding not seen, always go to onboarding (unless already there)
      if (!hasSeenOnboarding && loc != '/onboarding') {
        return '/onboarding';
      }

      // 2. If onboarding seen but not authenticated, only allow login/register/verify
      final unauthenticatedRoutes = ['/login', '/register', '/verify-email'];
      if (hasSeenOnboarding &&
          token == null &&
          !unauthenticatedRoutes.contains(loc)) {
        return '/login';
      }

      // 3. If authenticated, and trying to access login/onboarding, go to home
      // Prevent showing welcome if onboarding is done and token is present
      if (token != null && hasSeenOnboarding && loc == '/login') {
        return '/dashboard';
      }

      // Otherwise, allow navigation
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/'),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),

      GoRoute(
        path: '/profile-complete',
        name: 'profile-complete',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ProfileCompleteScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/new-transaction',
        name: 'new-transaction',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const NewTransactionPage(),
        ),
      ),
      GoRoute(
        path: '/join-transaction',
        name: 'join-transaction',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const JoinTransactionPage(),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: VerifyEmailPage(email: state.extra as String),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: MainNavPage(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SettingsPage(),
        ),
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   pageBuilder: (context, state) => buildPageWithDefaultTransition(
      //     context: context,
      //     state: state,
      //     child: const HomeScreen(),
      //   ),
      // ),
    ],
  );
}
