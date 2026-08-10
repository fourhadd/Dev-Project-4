// features/location/domain/entities/location_point.dart

class LocationPoint {
  final double latitude;
  final double longitude;

  final String? cityName;
  final String? country;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
  });
}
