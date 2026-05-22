import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:lms_student/features/explore/presentation/bloc/explore_event.dart';
import 'package:lms_student/features/explore/presentation/bloc/explore_state.dart';
import 'package:lms_student/features/explore/presentation/screens/widget/custom_category.dart';
import 'package:lms_student/features/widgets/course_card_vertical.dart';
import 'package:lms_student/features/widgets/empty_state_widget.dart';
import 'package:lms_student/core/localization/app_localizations.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(
      const GetpackagesEvent(page: 1, pageSize: 10),
    );
    context.read<ExploreBloc>().add(const GetCoursesEvent(page: 1));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ExploreBloc>().state;
      if (state.courseStatus == ExploreStatus.success &&
          !state.isCoursePaginationLoading &&
          (state.courseUIModel?.currentPage ?? 0) <
              (state.courseUIModel?.totalPages ?? 0)) {
        context.read<ExploreBloc>().add(
          GetCoursesEvent(page: (state.courseUIModel?.currentPage ?? 0) + 1),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ExploreBloc>().add(
            const GetpackagesEvent(page: 1, pageSize: 10),
          );
          context.read<ExploreBloc>().add(const GetCoursesEvent(page: 1));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 9.w, right: 15.w, top: 18.h),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 10.h),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 300.w,
              //       child: CustomTextFormField(
              //         prefixIcon: Icon(
              //           Icons.search,
              //           color: context.colorScheme.onSurface,
              //         ),
              //         hintText: context.tr('search_courses_instructors'),
              //       ),
              //     ),
              //     const Spacer(),
              //     Container(
              //       width: 42.w,
              //       height: 42.h,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: context.colorScheme.onPrimary,
              //       ),
              //       child: Icon(Icons.tune, color: context.colorScheme.primary),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 10.h),
              // CustomCategoryItem(),
              // SizedBox(height: 13.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: context.colorScheme.primary,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        context.tr('learning_tracks'),
                        style: context.textTheme.titleLarge!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      context.push(AppRoutes.viewAllPackages);
                    },
                    child: Text(
                      context.tr('see_all'),
                      style: context.textTheme.labelLarge!.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 260.h,
                child: BlocBuilder<ExploreBloc, ExploreState>(
                  builder: (context, state) {
                    if (state.packageStatus == ExploreStatus.loading) {
                      return SizedBox(
                        height: 280.h,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state.packageStatus == ExploreStatus.failure) {
                      return SizedBox(
                        height: 280.h,
                        child: Center(
                          child: Text('Error : ${state.packageError}'),
                        ),
                      );
                    }
                    if (state.packageStatus == ExploreStatus.success) {
                      if (state.packages.isEmpty) {
                        return EmptyStateWidget(
                          title: context.tr('no_packages_yet'),
                          subtitle: context.tr('no_packages_desc'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.packages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 8.w,
                            ),
                            child: IntrinsicHeight(
                              child: InkWell(
                                onTap: () {
                                  log(
                                    "jhcacsjbajs${state.packages[index].categories}",
                                  );
                                },
                                child: CustomCategory(
                                  title: state.packages[index].title,
                                  description:
                                      state.packages[index].description,
                                  courses: state.packages[index].coursesCount,
                                  price: state.packages[index].price,
                                  category: state.packages[index].categories,
                                  slug: state.packages[index].slug,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: context.colorScheme.primary,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        context.tr('many_courses'),
                        style: context.textTheme.titleLarge!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
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
              SizedBox(height: 15.h),
              BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state.courseStatus == ExploreStatus.loading) {
                    return SizedBox(
                      height: 280.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.courseStatus == ExploreStatus.failure) {
                    return SizedBox(
                      height: 280.h,
                      child: Center(
                        child: Text('Error : ${state.courseError}'),
                      ),
                    );
                  }
                  if (state.courseStatus == ExploreStatus.success) {
                    if (state.courses.isEmpty) {
                      return EmptyStateWidget(
                        title: context.tr('no_explore_courses_yet'),
                        subtitle: context.tr('no_explore_courses_desc'),
                      );
                    }
                    return Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth = (constraints.maxWidth - 8.w) / 2;
                            return Wrap(
                              spacing: 8.w,
                              runSpacing: 16.h,
                              children: state.courses.map((course) {
                                return InkWell(
                                  onTap: () {
                                    log(
                                      " nammmmmmmmmmmmmmmme ${course.isenrolled}",
                                    );
                                    context.push(
                                      AppRoutes.courseDetailsScreen,
                                      extra: {
                                        'slug': course.slug,
                                        'isEnrolled': course.isenrolled,
                                      },
                                    );
                                  },
                                  child: CourseCardVertical(
                                    width: cardWidth / ScreenUtil().scaleWidth,
                                    title: course.title,
                                    price: course.price,
                                    imagePath: course.image,
                                    rating: course.avgRating,
                                    totalStudents: course.studentsCount,
                                    description: course.description,
                                    instructorName: course.instructorName,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        if (state.isCoursePaginationLoading)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
