import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_student/core/common_logic/domain/repositories/course_repository.dart';

part 'course_rating_event.dart';
part 'course_rating_state.dart';

class CourseRatingBloc extends Bloc<CourseRatingEvent, CourseRatingState> {
  final CourseRepository courseRepository;

  CourseRatingBloc({required this.courseRepository})
      : super(CourseRatingInitial()) {
    on<SubmitCourseRating>(_onSubmitCourseRating);
  }

  Future<void> _onSubmitCourseRating(
    SubmitCourseRating event,
    Emitter<CourseRatingState> emit,
  ) async {
    emit(CourseRatingLoading());

    try {
      final result = await courseRepository.rateCourse(event.slug, event.rating);

      result.fold(
        (error) => emit(CourseRatingError(message: error)),
        (response) => emit(CourseRatingSuccess(response: response)),
      );
    } catch (e) {
      emit(CourseRatingError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
