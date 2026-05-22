import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:lms_student/features/my_courses/presentation/bloc/my_courses_event.dart';
import 'package:lms_student/features/my_courses/presentation/bloc/my_courses_state.dart';
import 'package:lms_student/features/my_courses/presentation/widgets/course_filter_chip.dart';
import 'package:lms_student/features/widgets/course_card_horizontal.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';
import 'package:lms_student/core/services/remote/endpoints.dart';
import 'package:lms_student/features/home/presentation/get_data_from_cache.dart';
import 'package:lms_student/features/widgets/custom_image.dart';

class MyCoursesScreenAfterLogin extends StatefulWidget {
  const MyCoursesScreenAfterLogin({super.key});

  @override
  State<MyCoursesScreenAfterLogin> createState() =>
      _MyCoursesScreenAfterLoginState();
}

class _MyCoursesScreenAfterLoginState extends State<MyCoursesScreenAfterLogin> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MyCoursesBloc>().add(const GetMyCoursesEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<MyCoursesBloc>().state;
      if (state.status == MyCoursesStatus.loaded &&
          !state.isPaginationLoading &&
          (state.enrollmentsUIModel?.currentPage ?? 0) <
              (state.enrollmentsUIModel?.totalPages ?? 0)) {
        context.read<MyCoursesBloc>().add(
          GetMyCoursesEvent(
            page: (state.enrollmentsUIModel?.currentPage ?? 0) + 1,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('my_courses'),
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.secondary,
                    ),
                    child: CustomImage(
                      imagePath: getDataFromCache(ApiKey.image),
                      width: 44.w,
                      height: 44.h,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Search Bar
              CustomTextFormField(
                controller: _searchController,
                hintText: context.tr('search_courses_instructors'),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                onChanged: (value) {
                  context.read<MyCoursesBloc>().add(
                    SearchMyCoursesEvent(value),
                  );
                },
              ),
              SizedBox(height: 20.h),
              // Filters
              BlocBuilder<MyCoursesBloc, MyCoursesState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CourseFilterChip(
                        label: context.tr('all_courses'),
                        statusKey: 'All',
                        isSelected: state.filterStatus == 'All',
                      ),
                      SizedBox(width: 10.w),
                      CourseFilterChip(
                        label: context.tr('ongoing'),
                        statusKey: 'Ongoing',
                        isSelected: state.filterStatus == 'Ongoing',
                      ),
                      SizedBox(width: 10.w),
                      CourseFilterChip(
                        label: context.tr('completed'),
                        statusKey: 'Completed',
                        isSelected: state.filterStatus == 'Completed',
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              // Courses List
              Expanded(
                child: BlocBuilder<MyCoursesBloc, MyCoursesState>(
                  builder: (context, state) {
                    if (state.status == MyCoursesStatus.loading &&
                        state.allEnrollments.isEmpty) {
                      return const LoadingIndicatorWidget();
                    }
                    if (state.status == MyCoursesStatus.error &&
                        state.allEnrollments.isEmpty) {
                      return ErrorFeedbackWidget(
                        errorMessage: state.errorMessage ?? context.tr('error'),

                        onRetry: () {
                          context.read<MyCoursesBloc>().add(
                            const GetMyCoursesEvent(),
                          );
                        },
                      );
                    }

                    final courses = state.filteredEnrollments;

                    if (courses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64.sp,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              context.tr('no_courses_found'),
                              style: context.textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<MyCoursesBloc>().add(
                          const GetMyCoursesEvent(),
                        );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            courses.length +
                            (state.isPaginationLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= courses.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final course = courses[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: CourseCardHorizontal(
                              title: course.title,
                              instructorName: course.instructorName,
                              imagePath: course.image,
                              progressPercentage: course.progress,
                              progressValue: course.progress?.toDouble() ?? 0,
                              onTap: () {
                                context.push(
                                  AppRoutes.courseDetailsScreen,
                                  extra: {
                                    'slug': course.slug,
                                    'isEnrolled': true,
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
