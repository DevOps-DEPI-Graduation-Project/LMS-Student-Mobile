import 'package:dartz/dartz.dart';
import 'package:lms_student/core/common_logic/data/model/course/course_model.dart';
import 'package:lms_student/core/common_logic/data/model/course/responsecoursebyslugmodel.dart';
import 'package:lms_student/core/common_logic/domain/repositories/course_paginated_ui_model.dart';

abstract class CourseRepository {
  Future<Either<String, CoursePaginatedUIModel>> getAllCourses({
    int? page,
    int? pageSize,
  });
  Future<Either<String, CoursePaginatedUIModel>> getMyEnrollments({
    int? page,
    int? pageSize,
  });
  Future<Either<String, ResponseCourseBySlugModel>> getCourseBySlug(
    String slug,
  );
  Future<Either<String, ResponseCourseBySlugModel>> enrollCourseBySlug(
    String slug,
  );
  Future<Either<String, List<CourseModel>>> searchInCourses(String query);
  Future<Either<String, Map<String, dynamic>>> rateCourse(
    String slug,
    int rating,
  );
}
