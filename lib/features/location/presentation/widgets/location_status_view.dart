// features/location/presentation/widgets/location_status_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import 'location_coordinates_card.dart';
import 'location_radar.dart';

const _signal = Color(0xFF4FD1C5);

class LocationStatusView extends StatelessWidget {
  final LocationState state;
  const LocationStatusView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    final isSearching = state is LocationLoading || state is LocationInitial;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LocationRadar(
          active: isSearching,
          ringColor: state is LocationLoaded ? _signal : _accentFor(state),
          pinColor: state is LocationLoaded ? _signal : _accentFor(state),
          icon: _iconFor(state),
        ),
        SizedBox(height: 20.h),
        Text(
          _eyebrowFor(state),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          _headlineFor(state),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        SizedBox(height: 28.h),
        if (state is LocationLoaded)
          LocationCoordinatesCard(
              point: (state as LocationLoaded).point,
              onRefresh: cubit.fetchLocation)
        else if (!isSearching)
          _RetryButton(
              label: _actionLabelFor(state),
              onPressed: _actionFor(state, cubit)),
      ],
    );
  }

  String _eyebrowFor(LocationState state) {
    if (state is LocationLoaded) return 'SIGNAL LOCKED';
    if (state is LocationLoading || state is LocationInitial) {
      return 'ACQUIRING SIGNAL';
    }
    return 'SIGNAL LOST';
  }

  String _headlineFor(LocationState state) {
    if (state is LocationLoaded) return 'Position acquired';
    if (state is LocationLoading || state is LocationInitial) {
      return 'Searching for your position…';
    }
    if (state is LocationPermissionDenied) return 'Permission was denied';
    if (state is LocationPermissionDeniedForever) {
      return 'Permission is permanently denied';
    }
    if (state is LocationServiceDisabled) return 'Location services are off';
    return 'Could not get your location';
  }

  IconData _iconFor(LocationState state) {
    if (state is LocationLoaded) return Icons.check_rounded;
    if (state is LocationLoading || state is LocationInitial) {
      return Icons.my_location_rounded;
    }
    if (state is LocationPermissionDenied ||
        state is LocationPermissionDeniedForever) {
      return Icons.location_disabled_rounded;
    }
    if (state is LocationServiceDisabled) return Icons.location_off_rounded;
    return Icons.error_outline_rounded;
  }

  Color _accentFor(LocationState state) {
    if (state is LocationPermissionDenied ||
        state is LocationPermissionDeniedForever ||
        state is LocationServiceDisabled) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  String _actionLabelFor(LocationState state) {
    if (state is LocationPermissionDeniedForever) return 'Open settings';
    if (state is LocationError) return 'Retry';
    return 'Try again';
  }

  VoidCallback _actionFor(LocationState state, LocationCubit cubit) {
    if (state is LocationPermissionDeniedForever) return cubit.openSettings;
    return cubit.fetchLocation;
  }
}

class _RetryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _RetryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
    );
  }
}
