// features/location/presentation/screens/location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injections.dart';
import '../cubit/location_cubit.dart';
import '../widgets/location_content.dart';

const _gradientTop = Color(0xFF12142B);
const _gradientBottom = Color(0xFF2C317A);

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationCubit>()..fetchLocation(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('My location'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_gradientTop, _gradientBottom],
            ),
          ),
          child: const SafeArea(child: LocationContent()),
        ),
      ),
    );
  }
}
