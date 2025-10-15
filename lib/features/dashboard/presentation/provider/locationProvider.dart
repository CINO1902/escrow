import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/locationController.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);
