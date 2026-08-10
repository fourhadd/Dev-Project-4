// features/location/data/repositories/location_repository_impl.dart
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_point_model.dart';
import 'location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final Geocoding _geocoding = Geocoding();

  @override
  Future<LocationResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult(LocationStatus.serviceDisabled);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult(LocationStatus.permissionDenied);
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationStatus.permissionDeniedForever);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      var model = LocationPointModel.fromPosition(position);
      final placemark =
          await _resolvePlacemark(position.latitude, position.longitude);
      if (placemark != null) {
        model = model.copyWith(cityName: placemark.$1, country: placemark.$2);
      }
      return LocationResult(LocationStatus.success, model.toEntity());
    } catch (_) {
      return const LocationResult(LocationStatus.error);
    }
  }

  Future<(String?, String?)?> _resolvePlacemark(double lat, double lng) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final city = _firstNonEmpty(
          [p.locality, p.subAdministrativeArea, p.administrativeArea]);
      return (city, p.country?.isNotEmpty == true ? p.country : null);
    } catch (_) {
      return null;
    }
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.trim().isNotEmpty) return v;
    }
    return null;
  }

  @override
  Future<void> openSettings() => Geolocator.openAppSettings();
}
