import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/location_cubit.dart';
import '../../cubit/location_state.dart';
import 'location_status_view.dart';

class LocationContent extends StatelessWidget {
  const LocationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) => LocationStatusView(state: state),
        ),
      ),
    );
  }
}
