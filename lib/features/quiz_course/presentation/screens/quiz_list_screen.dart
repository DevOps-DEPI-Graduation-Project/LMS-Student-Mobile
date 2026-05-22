import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/features/quiz_course/presentation/bloc/quiz_course_bloc.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';
import 'package:lms_student/features/widgets/empty_state_widget.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';
import 'package:go_router/go_router.dart';
import 'widgets/performance_summary_card.dart';
import 'widgets/quiz_card.dart';

class QuizListScreen extends StatefulWidget {
  final String courseSlug;
  const QuizListScreen({super.key, required this.courseSlug});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >=
            notification.metrics.maxScrollExtent * 0.8) {
      final state = context.read<QuizCourseBloc>().state;
      if (state is GetQuizzesSuccess) {
        final uiModel = state.uiModel;
        if (uiModel != null &&
            uiModel.currentPage < uiModel.totalPages &&
            !state.isPaginationLoading) {
          context.read<QuizCourseBloc>().add(
            GetQuizzesByCourseEvent(
              widget.courseSlug,
              page: uiModel.currentPage + 1,
            ),
          );
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('exams'), style: context.textTheme.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<QuizCourseBloc, QuizCourseState>(
        buildWhen: (previous, current) =>
            current is GetQuizzesLoading ||
            current is GetQuizzesSuccess ||
            current is GetQuizzesError,
        builder: (context, state) {
          if (state is GetQuizzesLoading) {
            return const LoadingIndicatorWidget();
          } else if (state is GetQuizzesError) {
            return ErrorFeedbackWidget(
              errorMessage: state.message,
              onRetry: () => context.read<QuizCourseBloc>().add(
                GetQuizzesByCourseEvent(widget.courseSlug),
              ),
            );
          } else if (state is GetQuizzesSuccess) {
            final quizzes = state.uiModel?.quizzes ?? [];
            if (quizzes.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.quiz_outlined,
                title: context.tr('no_quizzes_found'),
              );
            }

            return Column(
              children: [
                PerformanceSummaryCard(
                  overallBestScore: state.uiModel?.overallBestScore ?? '?%',
                  completedQuizzes: state.uiModel?.completedQuizzes ?? '?',
                ),
                Expanded(
                  child: _buildQuizList(quizzes, state.isPaginationLoading),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuizList(List quizzes, bool isPaginating) {
    if (quizzes.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.quiz_outlined,
        title: context.tr('no_quizzes_found'),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: quizzes.length + (isPaginating ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index < quizzes.length) {
            return QuizCard(quiz: quizzes[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
