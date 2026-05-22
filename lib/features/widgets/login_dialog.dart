import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/widgets/custom_outlined_button.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 8,
      backgroundColor: context.colorScheme.surface,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: context.colorScheme.primary,
                size: 36.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              context.tr('login_required_title'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              context.tr('login_required_description'),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            CustomPrimaryButton(
              text: context.tr('login_required_btn_login'),
              width: double.infinity,
              onTap: () {
                context.pop();
                context.push(AppRoutes.loginScreen);
              },
            ),
            SizedBox(height: 12.h),
            CustomOutlinedButton(
              text: context.tr('login_required_btn_cancel'),
              width: double.infinity,
              onTap: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
