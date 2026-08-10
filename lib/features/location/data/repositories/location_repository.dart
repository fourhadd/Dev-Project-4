import '../../domain/entities/location_point.dart';

enum LocationStatus { success, serviceDisabled, permissionDenied, permissionDeniedForever, error }

class LocationResult {
  final LocationStatus status;
  final LocationPoint? point;
  const LocationResult(this.status, [this.point]);
}

abstract class LocationRepository {
  Future<LocationResult> getCurrentLocation();
  Future<void> openSettings();
}
