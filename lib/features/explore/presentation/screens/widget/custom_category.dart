// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/core/services/local/cache_helper.dart';
import 'package:lms_student/core/services/remote/endpoints.dart';
import 'package:lms_student/features/widgets/login_dialog.dart';

class CustomCategory extends StatefulWidget {
  final String title;
  final String description;
  final String slug;
  final int courses;
  final double price;
  final List<String> category;
  const CustomCategory({
    Key? key,
    required this.title,
    required this.description,
    required this.slug,
    required this.courses,
    required this.price,
    required this.category,
  }) : super(key: key);

  @override
  State<CustomCategory> createState() => _CustomCategoryState();
}

class _CustomCategoryState extends State<CustomCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
      width: 332.w,
      // height: 262.h,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 18.r,
            offset: Offset(4, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            maxLines: 2,
            style: context.textTheme.labelLarge!.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            widget.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 15.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.category.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    width: 65.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      widget.category[index],
                      style: context.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 15.h),
          Divider(
            color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            height: 2.w,
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_sharp,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "${widget.courses} Courses",
                    style: context.textTheme.labelMedium!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5.w),
              Row(
                children: [
                  Icon(Icons.attach_money, color: context.colorScheme.primary),
                  SizedBox(width: 5.w),
                  Text(
                    " ${widget.price}",
                    style: context.textTheme.labelMedium!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              CustomPrimaryButton(
                text: context.tr('join_now'),
                width: 86,
                height: 33,
                textStyle: context.textTheme.labelLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
                onTap: () {
                  final token = CacheHelper.getDataString(key: ApiKey.accessToken);
                  if (token == null || token.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => const LoginDialog(),
                    );
                    return;
                  }
                  context.push(AppRoutes.packageDetails, extra: widget.slug);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
