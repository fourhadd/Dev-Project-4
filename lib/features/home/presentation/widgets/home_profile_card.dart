// features/home/presentation/widgets/home_profile_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class HomeProfileCard extends StatelessWidget {
  const HomeProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is AuthAuthenticated,
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84.w,
              height: 84.h,
              padding: EdgeInsets.all(3.w),
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
                      blurRadius: 24,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.gradientTop,
                child: Icon(Icons.person_rounded,
                    size: 38.sp, color: AppColors.white),
              ),
            ),
            SizedBox(height: 18.h),
            Text('Welcome, ${user?.name ?? ''}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white)),
            SizedBox(height: 6.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mail_outline_rounded,
                    size: 14.sp, color: AppColors.onDarkMuted),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(user?.email ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.sp, color: AppColors.onDarkMuted)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
