import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/features/material_course/presentation/bloc/material_course_bloc.dart';
import 'package:lms_student/features/material_course/presentation/bloc/material_course_event.dart';
import 'package:lms_student/features/material_course/presentation/bloc/material_course_state.dart';
import 'package:lms_student/features/material_course/presentation/screens/widgets/material_card.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/features/widgets/empty_state_widget.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';

class MaterialCourseScreen extends StatefulWidget {
  final String courseTitle;
  final String courseSlug;
  const MaterialCourseScreen({
    super.key,
    required this.courseTitle,
    required this.courseSlug,
  });

  @override
  State<MaterialCourseScreen> createState() => _MaterialCourseScreenState();
}

class _MaterialCourseScreenState extends State<MaterialCourseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CourseMaterialsBloc>().add(
      GetCourseMaterialsEvent(slug: widget.courseSlug),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<CourseMaterialsBloc>().state;
      if (state is CourseMaterialsLoaded) {
        final model = state.materialsListUIModel;
        if (model.currentPage < model.totalPages &&
            !state.isPaginationLoading) {
          context.read<CourseMaterialsBloc>().add(
            GetCourseMaterialsEvent(
              slug: widget.courseSlug,
              page: model.currentPage + 1,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.courseTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: _searchController,
              hintText: context.tr('search_materials_hint'),
              prefixIcon: Icon(
                Icons.search,
                color: context.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              height: 8.h,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<CourseMaterialsBloc, CourseMaterialsState>(
                builder: (context, state) {
                  if (state is CourseMaterialsLoading) {
                    return const LoadingIndicatorWidget();
                  }

                  if (state is CourseMaterialsError) {
                    return ErrorFeedbackWidget(
                      errorMessage: state.message,
                      onRetry: () {
                        context.read<CourseMaterialsBloc>().add(
                          GetCourseMaterialsEvent(slug: widget.courseSlug),
                        );
                      },
                    );
                  }

                  if (state is CourseMaterialsLoaded) {
                    final allMaterials = state.materialsListUIModel.materials;
                    final filteredMaterials = allMaterials.where((m) {
                      final name = m.materialName.toLowerCase();
                      final query = _searchQuery.toLowerCase();
                      return name.contains(query);
                    }).toList();

                    if (filteredMaterials.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.folder_open_outlined,
                        title: _searchQuery.isEmpty
                            ? context.tr('no_materials_found')
                            : context.tr('no_matching_materials'),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredMaterials.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MaterialCard(
                                material: filteredMaterials[index],
                              );
                            },
                          ),
                        ),
                        if (state.isPaginationLoading)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const LoadingIndicatorWidget(),
                          ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
