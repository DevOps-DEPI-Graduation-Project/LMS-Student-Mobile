import 'package:dartz/dartz.dart';
import 'package:lms_student/core/common_logic/data/model/course/responsecoursebyslugmodel.dart';
import 'package:lms_student/core/services/remote/api_consumer.dart';
import 'package:lms_student/core/services/remote/endpoints.dart';
import 'package:lms_student/core/common_logic/data/model/course/course_model.dart';
import 'package:lms_student/core/common_logic/data/model/course/response_course_model.dart';
import 'package:lms_student/core/common_logic/domain/repositories/course_repository.dart';
import 'package:lms_student/core/common_logic/domain/repositories/course_paginated_ui_model.dart';
import 'package:lms_student/core/utils/api_query_params.dart';

class CourseRepositoryImpl implements CourseRepository {
  final ApiConsumer apiConsumer;

  CourseRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, CoursePaginatedUIModel>> getAllCourses({
    int? page,
    int? pageSize,
  }) async {
    final result = await apiConsumer.get<ResponseCourseModel>(
      EndPoint.allCourses,
      queryParameters: ApiQueryParams.pagination(
        page: page,
        pageSize: pageSize,
      ),
      fromJson: (json) => ResponseCourseModel.fromJson(json),
    );

    return result.fold(
      (error) => Left(error),
      (model) => Right(
        CoursePaginatedUIModel(
          courses: model.data,
          totalPages: model.totalPages ?? 0,
          currentPage: model.currentPage ?? 0,
          totalCourses: model.totalCourses ?? 0,
        ),
      ),
    );
  }

  @override
  Future<Either<String, ResponseCourseBySlugModel>> getCourseBySlug(
    String slug,
  ) async {
    return await apiConsumer.get<ResponseCourseBySlugModel>(
      '${EndPoint.courseBySlug}$slug/',
      fromJson: (json) => ResponseCourseBySlugModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, List<CourseModel>>> searchInCourses(String query) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, CoursePaginatedUIModel>> getMyEnrollments({
    int? page,
    int? pageSize,
  }) async {
    final result = await apiConsumer.get<ResponseCourseModel>(
      EndPoint.myEnrollments,
      queryParameters: ApiQueryParams.pagination(
        page: page,
        pageSize: pageSize,
      ),
      fromJson: (json) => ResponseCourseModel.fromJson(json),
    );

    return result.fold(
      (error) => Left(error),
      (model) => Right(
        CoursePaginatedUIModel(
          courses: model.data,
          totalPages: model.totalPages ?? 0,
          currentPage: model.currentPage ?? 0,
          totalCourses: model.totalCourses ?? 0,
        ),
      ),
    );
  }

  @override
  Future<Either<String, ResponseCourseBySlugModel>> enrollCourseBySlug(
    String slug,
  ) async {
    return await apiConsumer.post<ResponseCourseBySlugModel>(
      '${EndPoint.enrollCourse}$slug/',
      fromJson: (json) => ResponseCourseBySlugModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, Map<String, dynamic>>> rateCourse(
    String slug,
    int rating,
  ) async {
    return await apiConsumer.post<Map<String, dynamic>>(
      EndPoint.courseRating(slug),
      data: {'rate': rating},
      fromJson: (json) => json,
    );
  }
}
