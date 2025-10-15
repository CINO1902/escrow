import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initialRouteProvider = StateProvider<String?>((ref) => null);

final routeInitializerProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final String? token = prefs.getString('jwt_token');

  String route;
  if (!hasSeenOnboarding) {
    route = '/onboarding';
  } else if (token != null) {
    route = '/home';
  } else {
    route = '/login';
  }

  ref.read(initialRouteProvider.notifier).state = route;
});
