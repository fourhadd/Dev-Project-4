// features/home/presentation/widgets/home_logout_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class HomeLogoutButton extends StatelessWidget {
  const HomeLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: IconButton(
        icon: Icon(Icons.logout_rounded, color: AppColors.white, size: 22.sp),
        tooltip: 'Log out',
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.gradientBottom,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r)),
              title: const Text('Log out?',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w700)),
              content: Text('You will need to log in again to continue.',
                  style: TextStyle(
                      color: AppColors.onDarkMuted, fontSize: 13.5.sp)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.onDarkMuted)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Log out',
                      style: TextStyle(
                          color: AppColors.error, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            context.read<AuthCubit>().logout();
          }
        },
      ),
    );
  }
}
