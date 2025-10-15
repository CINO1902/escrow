// --- Location State & Provider ---
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationState {
  final String? location;
  final bool loading;
  final String? error;
  final bool deniedForever;
  const LocationState({
    this.location,
    this.loading = false,
    this.error,
    this.deniedForever = false,
  });

  LocationState copyWith({
    String? location,
    bool? loading,
    String? error,
    bool? deniedForever,
  }) {
    return LocationState(
      location: location ?? this.location,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      deniedForever: deniedForever ?? this.deniedForever,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState(loading: true)) {
    fetchLocation();
  }

  bool _openedSettings = false;

  Future<void> fetchLocation() async {
    state = state.copyWith(loading: true, error: null, deniedForever: false);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          error: 'Location services are disabled',
          loading: false,
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            error: 'Location permissions are denied',
            loading: false,
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          error: 'Location permissions are permanently denied',
          loading: false,
          deniedForever: true,
        );
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        state = state.copyWith(
          location:
              '${place.locality ?? place.subAdministrativeArea ?? ''}, ${place.country ?? ''}',
          loading: false,
          error: null,
          deniedForever: false,
        );
      } else {
        state = state.copyWith(
          location: 'Unknown location',
          loading: false,
          error: null,
          deniedForever: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get location',
        loading: false,
        deniedForever: false,
      );
    }
  }

  void markOpenedSettings() {
    _openedSettings = true;
  }

  void onAppResumed() {
    if (_openedSettings && state.deniedForever) {
      _openedSettings = false;
      fetchLocation();
    }
  }
}
