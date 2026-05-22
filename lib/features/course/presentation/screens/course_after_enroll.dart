import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/course/presentation/bloc/coursedetails_bloc.dart';
import 'package:lms_student/features/course/presentation/bloc/course_rating_bloc.dart';
import 'package:lms_student/features/course/presentation/screens/widget/custom_course_material.dart';
import 'package:lms_student/features/course/presentation/screens/widget/course_rating_card.dart';
import 'package:lms_student/core/di/service_locator.dart';
import 'package:lms_student/features/widgets/custom_image.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';

class CourseAfterEnroll extends StatefulWidget {
  final String? slug;

  const CourseAfterEnroll({super.key, this.slug});

  @override
  State<CourseAfterEnroll> createState() => _CourseAfterEnrollState();
}

class _CourseAfterEnrollState extends State<CourseAfterEnroll> {
  @override
  void initState() {
    super.initState();
    if (widget.slug != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CoursedetailsBloc>().add(
            GetCourseDetails(slug: widget.slug!),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursedetailsBloc, CoursedetailsState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Scaffold(body: LoadingIndicatorWidget());
        }

        if (state is CourseError) {
          return Scaffold(
            body: ErrorFeedbackWidget(
              errorMessage: state.message,
              onRetry: () {
                if (widget.slug != null) {
                  context.read<CoursedetailsBloc>().add(
                    GetCourseDetails(slug: widget.slug!),
                  );
                }
              },
            ),
          );
        }

        if (state is CourseLoaded) {
          final course = state.course;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                course.title,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge,
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.share_outlined, size: 22.sp),
              //   ),
              // ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CustomImage(imagePath: course.image),
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: context.textTheme.displaySmall!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  CustomCourseMaterial(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.courseVideosScreen,
                                        extra: course.slug,
                                      );
                                    },
                                    text: context.tr('videos'),
                                    icon: Icons.play_circle,
                                    width: 105.w,
                                  ),
                                  SizedBox(width: 16.w),
                                  CustomCourseMaterial(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.materialCourseScreen,
                                        extra: {
                                          'courseTitle': course.title,
                                          'courseSlug': course.slug,
                                        },
                                      );
                                    },
                                    text: context.tr('files'),
                                    icon: Icons.folder,
                                    width: 105.w,
                                  ),
                                  SizedBox(width: 16.w),
                                  CustomCourseMaterial(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.quizList,
                                        extra: widget.slug,
                                      );
                                    },
                                    text: context.tr('quizzes'),
                                    icon: Icons.quiz,
                                    width: 105.w,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              course.description,
                              style: context.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 20.w,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: context.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            (course.avgRating ?? 0.0)
                                                .toStringAsFixed(2),
                                            style: context
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            context.tr('rating'),
                                            style:
                                                context.textTheme.labelMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "${course.studentsCount}",
                                            style: context
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            context.tr('students'),
                                            style:
                                                context.textTheme.labelMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              context.tr('instructor'),
                              style: context.textTheme.titleLarge,
                            ),

                            SizedBox(height: 15.h),
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  padding: EdgeInsets.all(12.r),
                                  child: Row(
                                    children: [
                                      CustomImage(
                                        imagePath: course.instructorImage,
                                        width: 56,
                                        height: 56,
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              course.instructorName,
                                              style:
                                                  context.textTheme.titleLarge,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              course.instructorBio,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                            BlocProvider(
                              create: (context) => sl<CourseRatingBloc>(),
                              child: CourseRatingCard(courseSlug: course.slug),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(body: LoadingIndicatorWidget());
      },
    );
  }
}
