import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double? height;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.search_off,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
