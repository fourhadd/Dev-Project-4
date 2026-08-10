import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/location_repository.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;

  LocationCubit({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(const LocationInitial());

  Future<void> fetchLocation() async {
    emit(const LocationLoading());
    final result = await _locationRepository.getCurrentLocation();
    switch (result.status) {
      case LocationStatus.success:
        emit(LocationLoaded(result.point!));
        break;
      case LocationStatus.permissionDenied:
        emit(const LocationPermissionDenied());
        break;
      case LocationStatus.permissionDeniedForever:
        emit(const LocationPermissionDeniedForever());
        break;
      case LocationStatus.serviceDisabled:
        emit(const LocationServiceDisabled());
        break;
      case LocationStatus.error:
        emit(const LocationError());
        break;
    }
  }

  Future<void> openSettings() => _locationRepository.openSettings();
}
