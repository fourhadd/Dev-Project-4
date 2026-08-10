// features/location/presentation/cubit/location_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/location_point.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final LocationPoint point;
  const LocationLoaded(this.point);
  @override
  List<Object?> get props => [point];
}

class LocationPermissionDenied extends LocationState {
  const LocationPermissionDenied();
}

class LocationPermissionDeniedForever extends LocationState {
  const LocationPermissionDeniedForever();
}

class LocationServiceDisabled extends LocationState {
  const LocationServiceDisabled();
}

class LocationError extends LocationState {
  const LocationError();
}
