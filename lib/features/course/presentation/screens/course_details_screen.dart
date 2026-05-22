import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/course/presentation/bloc/coursedetails_bloc.dart';
import 'package:lms_student/features/widgets/custom_image.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/widgets/custom_dialog.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';
import 'package:lms_student/core/services/local/cache_helper.dart';
import 'package:lms_student/core/services/remote/endpoints.dart';
import 'package:lms_student/features/widgets/login_dialog.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String? slug;
  final bool? isenroll;
  const CourseDetailsScreen({super.key, this.slug, this.isenroll});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
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
    if (widget.isenroll == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.pushReplacement(
            AppRoutes.courseAfterEnroll,
            extra: widget.slug,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursedetailsBloc, CoursedetailsState>(
      listener: (context, state) {
        if (state is CourseLoaded && state.course.isenrolled == true) {
          context.pushReplacement(
            AppRoutes.courseAfterEnroll,
            extra: state.course.slug,
          );
        } else if (state is CourseEnrollLoaded) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CustomDialog(
              icon: Icon(
                Icons.check_circle,
                color: dialogContext.colorScheme.secondary,
                size: 60.sp,
              ),
              title: dialogContext.tr('enroll_success_title'),
              description: dialogContext.tr('enroll_success_message'),
              primaryButtonText: dialogContext.tr('go_to_course'),
              primaryButtonOnTap: () {
                dialogContext.pop();
                context.pushReplacement(
                  AppRoutes.courseAfterEnroll,
                  extra: widget.slug,
                );
              },
            ),
          );
        } else if (state is CourseEnrollError) {
          showDialog(
            context: context,
            builder: (dialogContext) => CustomDialog(
              icon: Icon(
                Icons.error_outline,
                color: dialogContext.colorScheme.error,
                size: 60.sp,
              ),
              title: dialogContext.tr('error'),
              description: state.message,
              primaryButtonText: dialogContext.tr('retry'),
              primaryButtonOnTap: () {
                final bloc = context.read<CoursedetailsBloc>();
                dialogContext.pop();
                bloc.add(
                  EnrollCourse(slug: state.course.slug, course: state.course),
                );
              },
              secondaryButtonText: dialogContext.tr('cancel'),
              secondaryButtonOnTap: () => dialogContext.pop(),
            ),
          );
        }
      },
      child: BlocBuilder<CoursedetailsBloc, CoursedetailsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                context.tr('course_details'),
                style: context.textTheme.titleLarge,
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.share_outlined, size: 22.sp),
              //   ),
              // ],
            ),
            body: (() {
              if (state is CourseLoading) {
                return const LoadingIndicatorWidget();
              }
              if (state is CourseError) {
                return ErrorFeedbackWidget(
                  errorMessage: state.message,
                  onRetry: () {
                    if (widget.slug != null) {
                      context.read<CoursedetailsBloc>().add(
                        GetCourseDetails(slug: widget.slug!),
                      );
                    }
                  },
                );
              }
              if (state is CourseLoaded ||
                  state is CourseEnrollLoading ||
                  state is CourseEnrollLoaded ||
                  state is CourseEnrollError) {
                final course = state is CourseLoaded
                    ? state.course
                    : state is CourseEnrollLoading
                    ? state.course
                    : state is CourseEnrollLoaded
                    ? state.course
                    : (state as CourseEnrollError).course;
                final isEnrollLoading = state is CourseEnrollLoading;
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          CustomImage(
                            imagePath: course.image,
                            aspectRatio: 16 / 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: context.textTheme.displaySmall!
                                      .copyWith(
                                        color: context.colorScheme.primary,
                                      ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "\$${course.price.toInt()}",
                                  style: context.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  context.tr('about_this_course'),
                                  style: context.textTheme.titleLarge,
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  course.description,
                                  style: context.textTheme.bodyLarge,
                                ),
                                SizedBox(height: 15.h),
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
                                        color:
                                            context.colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
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
                                                  style: context
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  course.instructorBio,
                                                  style: context
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                      horizontal: 20.w,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: context.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "${course.avgRating}",
                                                style: context
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                context.tr('rating'),
                                                style: context
                                                    .textTheme
                                                    .labelMedium,
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
                                                style: context
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0.h),
                      child: CustomPrimaryButton(
                        text: isEnrollLoading
                            ? context.tr('sending')
                            : context.tr('enroll_now'),
                        textStyle: context.textTheme.labelLarge,
                        onTap: isEnrollLoading
                            ? null
                            : () {
                                final token = CacheHelper.getDataString(key: ApiKey.accessToken);
                                if (token == null || token.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => const LoginDialog(),
                                  );
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => CustomDialog(
                                    icon: Icon(
                                      Icons.help_outline,
                                      color: context.colorScheme.primary,
                                      size: 60.sp,
                                    ),
                                    title: context.tr('enroll_confirm_title'),
                                    description: context.tr(
                                      'enroll_confirm_message',
                                    ),
                                    primaryButtonText: context.tr('yes'),
                                    primaryButtonOnTap: () {
                                      final bloc = context
                                          .read<CoursedetailsBloc>();
                                      dialogContext.pop();
                                      bloc.add(
                                        EnrollCourse(
                                          slug: course.slug,
                                          course: course,
                                        ),
                                      );
                                    },
                                    secondaryButtonText: context.tr('no'),
                                    secondaryButtonOnTap: () =>
                                        dialogContext.pop(),
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            })(),
          );
        },
      ),
    );
  }
}
