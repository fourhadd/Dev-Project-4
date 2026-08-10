// features/location/presentation/widgets/location_coordinates_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/location_point.dart';

const _signal = Color(0xFF4FD1C5);

class LocationCoordinatesCard extends StatelessWidget {
  final LocationPoint point;
  final VoidCallback onRefresh;

  const LocationCoordinatesCard(
      {super.key, required this.point, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.sensors_rounded, size: 16.sp, color: _signal),
              SizedBox(width: 6.w),
              Text('SIGNAL LOCKED',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: _signal,
                  )),
              const Spacer(),
              IconButton(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh_rounded,
                    color: Colors.white.withValues(alpha: 0.85), size: 20.sp),
                tooltip: 'Refresh',
                splashRadius: 20.r,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (point.cityName != null) ...[
            _cityRow(context),
            SizedBox(height: 14.h),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            SizedBox(height: 14.h),
          ] else ...[
            Row(
              children: [
                Icon(Icons.location_city_rounded,
                    size: 16.sp, color: Colors.white.withValues(alpha: 0.4)),
                SizedBox(width: 8.w),
                Text('City unavailable',
                    style: TextStyle(
                        fontSize: 12.5.sp,
                        color: Colors.white.withValues(alpha: 0.45))),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            SizedBox(height: 14.h),
          ],
          _coordinateRow(context, label: 'LAT', value: point.latitude),
          SizedBox(height: 10.h),
          _coordinateRow(context, label: 'LNG', value: point.longitude),
        ],
      ),
    );
  }

  Widget _cityRow(BuildContext context) {
    final place = [point.cityName, point.country]
        .where((v) => v != null && v.isNotEmpty)
        .join(', ');
    return Row(
      children: [
        Icon(Icons.location_city_rounded,
            size: 18.sp, color: Colors.white.withValues(alpha: 0.85)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            place,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _coordinateRow(BuildContext context,
      {required String label, required double value}) {
    final formatted = value.toStringAsFixed(5);
    return Row(
      children: [
        SizedBox(
          width: 40.w,
          child: Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(
            formatted,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 19.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: formatted));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 1)),
              );
            }
          },
          icon: Icon(Icons.copy_rounded,
              size: 16.sp, color: Colors.white.withValues(alpha: 0.55)),
          splashRadius: 16.r,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
