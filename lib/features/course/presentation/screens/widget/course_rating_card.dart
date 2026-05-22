import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/features/course/presentation/bloc/course_rating_bloc.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';

class CourseRatingCard extends StatefulWidget {
  final String courseSlug;

  const CourseRatingCard({super.key, required this.courseSlug});

  @override
  State<CourseRatingCard> createState() => _CourseRatingCardState();
}

class _CourseRatingCardState extends State<CourseRatingCard> {
  int _selectedRating = 0;
  bool _isSubmittedSuccessfully = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseRatingBloc, CourseRatingState>(
      listener: (context, state) {
        if (state is CourseRatingSuccess) {
          setState(() {
            _isSubmittedSuccessfully = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('rating_submitted_success')),
              backgroundColor: context.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is CourseRatingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message.isNotEmpty
                    ? state.message
                    : context.tr('failed_to_submit_rating'),
              ),
              backgroundColor: context.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CourseRatingLoading;

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: context.colorScheme.outline.withOpacity(0.5),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.onSurface.withOpacity(0.04),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isSubmittedSuccessfully
                ? _buildSuccessView(context)
                : _buildRatingForm(context, isLoading),
          ),
        );
      },
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: context.colorScheme.primary,
            size: 48.r,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          context.tr('rating_submitted_success'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return Icon(
              Icons.star,
              color: starIndex <= _selectedRating
                  ? const Color(0xFFFFB236)
                  : context.colorScheme.outline.withOpacity(0.5),
              size: 28.r,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRatingForm(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.tr('your_feedback'),
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: context.colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          context.tr('rate_this_course'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isSelected = starIndex <= _selectedRating;
            return GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      setState(() {
                        _selectedRating = starIndex;
                      });
                    },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 1.0,
                    end: isSelected ? 1.15 : 1.0,
                  ),
                  duration: const Duration(milliseconds: 150),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        color: isSelected
                            ? const Color(0xFFFFB236)
                            : context.colorScheme.outline.withOpacity(0.7),
                        size: 38.r,
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            context.tr('select_star_to_leave_rating'),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: CustomPrimaryButton(
            text: context.tr('submit_rating'),
            onTap: (isLoading || _selectedRating == 0)
                ? null
                : () {
                    context.read<CourseRatingBloc>().add(
                          SubmitCourseRating(
                            slug: widget.courseSlug,
                            rating: _selectedRating,
                          ),
                        );
                  },
            width: double.infinity,
            suffixIcon: isLoading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      color: context.colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
