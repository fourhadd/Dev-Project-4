import 'package:geolocator/geolocator.dart';
import '../../domain/entities/location_point.dart';

class LocationPointModel {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;

  const LocationPointModel({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
  });

  factory LocationPointModel.fromPosition(Position position) =>
      LocationPointModel(latitude: position.latitude, longitude: position.longitude);

  LocationPointModel copyWith({String? cityName, String? country}) => LocationPointModel(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName ?? this.cityName,
        country: country ?? this.country,
      );

  LocationPoint toEntity() =>
      LocationPoint(latitude: latitude, longitude: longitude, cityName: cityName, country: country);
}
