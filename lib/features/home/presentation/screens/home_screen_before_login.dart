import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/core/theme/app_assets.dart';
import 'package:lms_student/features/home/presentation/bloc/home_bloc.dart';
import 'package:lms_student/features/home/widgets/custom_rich_text.dart';
import 'package:lms_student/features/home/widgets/feature_card.dart';
import 'package:lms_student/features/widgets/course_card_vertical.dart';
import 'package:lms_student/features/widgets/custom_outlined_button.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';

class HomeScreenBeforeLogin extends StatefulWidget {
  const HomeScreenBeforeLogin({super.key});

  @override
  State<HomeScreenBeforeLogin> createState() => _HomeScreenBeforeLoginState();
}

class _HomeScreenBeforeLoginState extends State<HomeScreenBeforeLogin> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.h,
        // الـ Logo على الشمال
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: context.colorScheme.surface.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.5),
                  width: 1.5.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                AppAssets.appLogoPng,
                width: 30.sp,
                height: 30.sp,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              context.tr('commit_ma3ana'),
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: CustomPrimaryButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onTap: () {
                context.push(AppRoutes.loginScreen);
              },
              text: context.tr('login'),
              textStyle: TextStyle(color: context.colorScheme.onSurface),

              width: 120,
              height: 40,
            ),
          ),
        ],
        backgroundColor: context.colorScheme.surface,
        elevation: 1,
        shadowColor: context.colorScheme.onSurface.withValues(alpha: 0.2),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const GetCoursesEvent());
        },
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
              height: 580.h,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    CustomRichText(),
                    SizedBox(height: 20.h),
                    Center(
                      child: Container(
                        width: 300.w,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface.withValues(
                            alpha: 0.04,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            context.tr('master_python_react'),
                            maxLines: 3,

                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.surface,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: CustomPrimaryButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        textStyle: TextStyle(
                          color: context.colorScheme.primary,
                        ),

                        text: context.tr('start_learning'),
                        //Todo: GO TO LOGIN SCREEN
                        onTap: () {
                          context.push(AppRoutes.loginScreen);
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: CustomOutlinedButton(
                        text: context.tr('browse_courses'),
                        textStyle: TextStyle(color: Colors.white),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          side: BorderSide(
                            width: 4,
                            color: context.colorScheme.surface.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        onTap: () {
                          // TODO
                        },
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Center(
                      child: Image.asset(
                        AppAssets.homePng,
                        fit: BoxFit.contain,
                        width: 200.w,
                        height: 120.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('featured_courses'),
                        style: context.textTheme.titleLarge!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.push(AppRoutes.viewAllCourse);
                        },
                        child: Text(
                          context.tr('view_all'),
                          style: context.textTheme.labelLarge!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state.coursesStatus == RequestStatus.loading) {
                        return const LoadingIndicatorWidget();
                      }
                      if (state.coursesStatus == RequestStatus.error) {
                        return ErrorFeedbackWidget(
                          errorMessage: state.coursesErrorMessage ?? 'Error',
                          onRetry: () {
                            context.read<HomeBloc>().add(
                              const GetCoursesEvent(),
                            );
                          },
                        );
                      }
                      if (state.coursesStatus == RequestStatus.loaded) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: state.courses.map((course) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: InkWell(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.courseDetailsScreen,
                                        extra: {
                                          'slug': course.slug,
                                          'isEnrolled': course.isenrolled,
                                        },
                                      );
                                    },
                                    child: CourseCardVertical(
                                      //Todo ::Handel nullable
                                      title: course.title,
                                      price: course.price,
                                      imagePath: course.image,
                                      rating: course.avgRating,
                                      totalStudents: course.studentsCount,
                                      width: 256,
                                      description: course.description,
                                      instructorName: course.instructorName,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 40.h),
                  FeatureCard(
                    description: context.tr('test_your_knowledge'),
                    path: "assets/icons/InteractiveQuizzes.png",
                    title: context.tr('interactive_quizzes'),
                  ),
                  SizedBox(height: 20.h),
                  FeatureCard(
                    description: context.tr('test_your_knowledge'),
                    path: "assets/icons/DiscussionBoards.png",
                    title: context.tr('discussion_boards'),
                  ),
                  SizedBox(height: 20.h),
                  FeatureCard(
                    description: context.tr('test_your_knowledge'),
                    path: "assets/icons/DownloadableResources.png",
                    title: context.tr('downloadable_resources'),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    context.tr('ready_to_start_journey'),
                    style: context.textTheme.headlineMedium!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Text(
                    context.tr('join_10k_learners'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 35.h),
                  CustomPrimaryButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    textStyle: TextStyle(color: context.colorScheme.onSurface),

                    text: context.tr('create_free_account'),
                    //Todo: GO TO REGISTER SCREEN
                    onTap: () {
                      context.push(AppRoutes.registerScreen);
                    },
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    context.tr('no_credit_card_required'),
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
            Divider(
              color: context.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.06,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.facebook,
                          size: 15.w,
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    InkWell(
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.06,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.alternate_email,
                          size: 15.w,
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  context.tr('all_rights_reserved'),
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
