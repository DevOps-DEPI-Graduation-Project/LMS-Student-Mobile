part of 'course_rating_bloc.dart';

sealed class CourseRatingEvent extends Equatable {
  const CourseRatingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCourseRating extends CourseRatingEvent {
  final String slug;
  final int rating;

  const SubmitCourseRating({required this.slug, required this.rating});

  @override
  List<Object?> get props => [slug, rating];
}
