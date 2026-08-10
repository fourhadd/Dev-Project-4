// features/auth/presentation/widgets/register_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72.w,
          height: 72.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 26,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: Icon(Icons.person_add_alt_1_rounded,
              color: AppColors.white, size: 32.sp),
        ),
        SizedBox(height: 20.h),
        Text('Create account',
            style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.white)),
        SizedBox(height: 8.h),
        Text('Fill in your details to get started',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.onDarkMuted)),
        SizedBox(height: 28.h),
      ],
    );
  }
}
