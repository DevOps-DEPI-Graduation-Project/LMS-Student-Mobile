import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/explore/presentation/screens/widget/custom_head_of_packe_detals.dart';
import 'package:lms_student/features/explore/presentation/screens/widget/custom_package_caregory.dart';
import 'package:lms_student/features/package_details/presentation/bloc/package_details_bloc.dart';
import 'package:lms_student/features/widgets/course_card_horizontal.dart';
// import 'package:lms_student/features/widgets/custom_primary_button.dart';

class PackageDetailsScreen extends StatefulWidget {
  final String slug;
  const PackageDetailsScreen({super.key, required this.slug});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PackageDetailsBloc>().add(
          GetpackagesEventBySlug(slug: widget.slug),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.tr('package_details')),
      ),
      body: BlocBuilder<PackageDetailsBloc, PackageDetailsState>(
        builder: (context, state) {
          if (state is PackageDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PackageDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PackageDetailsBloc>().add(
                        GetpackagesEventBySlug(slug: widget.slug),
                      );
                    },
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          } else if (state is PackageDetailsLoaded) {
            final package = state.packagesModel;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20.0.r),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomPackageCaregory(
                                category: package.categories,
                              ),
                              SizedBox(height: 5.h),
                              CustomHeadOfPackeDetals(
                                courseName: package.title,
                                lesson: package.coursesCount,
                              ),
                              if (package.description.isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                Divider(
                                  color: context.colorScheme.onSurface.withValues(
                                    alpha: 0.08,
                                  ),
                                  thickness: 1,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  context.tr('about_this_package'),
                                  style: context.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  package.description,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: context.colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        context.tr('included_courses'),
                        style: context.textTheme.displaySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: package.courses?.length ?? 0,
                        itemBuilder: (context, index) {
                          final course = package.courses?[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.r),
                            child: CourseCardHorizontal(
                              title: course!.title,
                              instructorName: course.instructorName,
                              rating: course.avgRating,
                              imagePath: course.image,
                              onTap: () {
                                context.push(
                                  AppRoutes.courseDetailsScreen,
                                  extra: {
                                    'slug': course.slug,
                                    'isEnrolled': course.isenrolled,
                                  },
                                );
                              },
                              //! TODO add Price
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //? enroll buttom
                // Container(
                //   padding: EdgeInsets.all(20.r),
                //   decoration: BoxDecoration(
                //     color: context.colorScheme.surface,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withValues(alpha: 0.2),
                //         blurRadius: 10,
                //         offset: const Offset(0, -2),
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     children: [
                //       Text(
                //         "\$${package.price}",
                //         style: context.textTheme.bodyLarge,
                //       ),
                //       const Spacer(),
                //       CustomPrimaryButton(
                //         text: context.tr('enroll_now'),
                //         onTap: () {},
                //         width: 240,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
