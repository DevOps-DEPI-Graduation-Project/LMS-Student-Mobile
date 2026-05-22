import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lms_student/core/common_logic/data/repositories/package_repository_impl.dart';
import 'package:lms_student/core/common_logic/domain/repositories/package_repository.dart';
import 'package:lms_student/core/services/local/cache_helper.dart';
import 'package:lms_student/core/services/remote/api_consumer.dart';
import 'package:lms_student/core/services/remote/dio_consumer.dart';
import 'package:lms_student/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lms_student/features/auth/domain/repositories/auth_repository.dart';
import 'package:lms_student/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms_student/features/course/presentation/bloc/coursedetails_bloc.dart';
import 'package:lms_student/features/course/presentation/bloc/course_rating_bloc.dart';
import 'package:lms_student/features/explore/data/repository/explore_repository_imp.dart';
import 'package:lms_student/features/explore/domain/repositories/explore_repository.dart';
import 'package:lms_student/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:lms_student/core/common_logic/data/repositories/course_repository_impl.dart';
import 'package:lms_student/core/common_logic/domain/repositories/course_repository.dart';
import 'package:lms_student/features/home/data/repositories/home_repository_impl.dart';
import 'package:lms_student/features/home/domain/repositories/home_repository.dart';
import 'package:lms_student/features/home/presentation/bloc/home_bloc.dart';
import 'package:lms_student/features/package_details/presentation/bloc/package_details_bloc.dart';
import 'package:lms_student/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:lms_student/features/splash/domain/splash_repository.dart';
import 'package:lms_student/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:lms_student/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lms_student/features/profile/domain/repositories/profile_repository.dart';
import 'package:lms_student/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lms_student/features/videos/data/repositories/videos_repository_impl.dart';
import 'package:lms_student/features/videos/domain/repositories/videos_repository.dart';
import 'package:lms_student/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:lms_student/features/quiz_course/data/repository/quiz_course_repository_impl.dart';
import 'package:lms_student/features/quiz_course/domain/repository/quiz_course_repository.dart';
import 'package:lms_student/features/quiz_course/presentation/bloc/quiz_course_bloc.dart';
import 'package:lms_student/features/my_courses/presentation/bloc/my_courses_bloc.dart';
import 'package:lms_student/features/material_course/data/repository/material_course_repository_impl.dart';
import 'package:lms_student/features/material_course/domain/repository/material_course_repository.dart';
import 'package:lms_student/features/material_course/presentation/bloc/material_course_bloc.dart';
import 'package:lms_student/core/theme/theme_cubit.dart';
import 'package:lms_student/core/localization/locale_cubit.dart';


final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  sl.registerLazySingleton<CacheHelper>(() => cacheHelper);
  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => LocaleCubit());

  // External
  sl.registerLazySingleton(() => Dio());

  // Remote package
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));

  // Features - Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Features - Course
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(apiConsumer: sl()),
  );

  // Features - Packages
  sl.registerLazySingleton<PackageRepository>(
    () => PackageRepositoryImpl(apiConsumer: sl()),
  );

  // Features - Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerLazySingleton(
    () => ProfileBloc(profileRepository: sl(), cacheHelper: sl()),
  );

  // Features - Home
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory(
    () => HomeBloc(courseRepository: sl(), homeRepository: sl()),
  );

  // Splash - Login
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(apiConsumer: sl(), cacheHelper: sl()),
  );
  sl.registerFactory(() => SplashBloc(splashRepository: sl()));

  // Features - Explore
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImp(apiConsumer: sl()),
  );

  // register factory for PackageBloc
  sl.registerFactory(
    () => ExploreBloc(
      exploreRepository: sl<ExploreRepository>(),
      packageRepository: sl<PackageRepository>(),
      courseRepository: sl<CourseRepository>(),
    ),
  );

  // register factory for course
  sl.registerFactory(
    () => CoursedetailsBloc(courseRepository: sl<CourseRepository>()),
  );

  sl.registerFactory(
    () => CourseRatingBloc(courseRepository: sl<CourseRepository>()),
  );

  sl.registerFactory(
    () => PackageDetailsBloc(packageRepository: sl<PackageRepository>()),
  );

  // Features - Videos
  sl.registerLazySingleton<VideosRepository>(
    () => VideosRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory(
    () => VideosBloc(videosRepository: sl<VideosRepository>()),
  );
  // Features - Quiz
  sl.registerLazySingleton<QuizCourseRepository>(
    () => QuizCourseRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory(() => QuizCourseBloc(repository: sl()));

  // Features - My Courses
  sl.registerFactory(() => MyCoursesBloc(courseRepository: sl()));

  // Features - Material Course
  sl.registerLazySingleton<MaterialCourseRepository>(
    () => MaterialCourseRepositoryImpl(apiConsumer: sl()),
  );
  sl.registerFactory(() => CourseMaterialsBloc(repository: sl()));
}

