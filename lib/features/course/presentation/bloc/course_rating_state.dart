part of 'course_rating_bloc.dart';

sealed class CourseRatingState extends Equatable {
  const CourseRatingState();

  @override
  List<Object?> get props => [];
}

class CourseRatingInitial extends CourseRatingState {}

class CourseRatingLoading extends CourseRatingState {}

class CourseRatingSuccess extends CourseRatingState {
  final Map<String, dynamic> response;

  const CourseRatingSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class CourseRatingError extends CourseRatingState {
  final String message;

  const CourseRatingError({required this.message});

  @override
  List<Object?> get props => [message];
}
