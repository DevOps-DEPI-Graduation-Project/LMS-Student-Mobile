import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/features/profile/presentation/screens/change_password_screen/widgets/change_password_body.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: context.colorScheme.onSurface,
                      size: 22.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      context.tr('back'),
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: ChangePasswordBody()),
          ],
        ),
      ),
    );
  }
}
