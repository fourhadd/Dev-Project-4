// features/home/presentation/widgets/home_location_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/main_button.dart';

class HomeLocationButton extends StatelessWidget {
  const HomeLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MainButton(
        label: 'Check my location',
        icon: Icons.my_location_rounded,
        onPressed: () => context.push('/location'),
      ),
    );
  }
}
