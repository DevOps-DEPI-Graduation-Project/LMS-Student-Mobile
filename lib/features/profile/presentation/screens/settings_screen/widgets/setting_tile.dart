import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/utils/get_responsive_size.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveValue(
      mobile: 22.sp,
      tablet: 18,
      desktop: 20,
    );
    final double containerPadding = context.responsiveValue(
      mobile: 10.r,
      tablet: 7,
      desktop: 8,
    );
    final double containerRadius = context.responsiveValue(
      mobile: 12.r,
      tablet: 9,
      desktop: 10,
    );
    final double trailingIconSize = context.responsiveValue(
      mobile: 14.sp,
      tablet: 12,
      desktop: 13,
    );

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: Container(
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: (iconColor ?? context.colorScheme.primary).withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(containerRadius),
        ),
        child: Icon(
          icon,
          color: iconColor ?? context.colorScheme.primary,
          size: iconSize,
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor ?? context.colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: trailingIconSize,
                  color: context.colorScheme.onSurfaceVariant,
                )
              : null),
    );
  }
}
