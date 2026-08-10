// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/glass_card.dart';
import '../widgets/home_profile_card.dart';
import '../widgets/home_location_button.dart';
import '../widgets/home_logout_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Home',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [HomeLogoutButton(), SizedBox()],
      ),
      body: AppGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const GlassCard(child: HomeProfileCard()),
                    SizedBox(height: 20.h),
                    const HomeLocationButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
