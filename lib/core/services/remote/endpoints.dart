class EndPoint {
  static String localUrl = "http://192.168.1.10:8000/api";
  static String remoteUrl =
      "http://lms-env.eba-8nbnpx42.us-east-1.elasticbeanstalk.com/api";

  static String baseUrl = remoteUrl;
  static String get mediaBaseUrl => baseUrl.replaceFirst('/api', '');

  // auth
  static String login = "/auth/login/"; // done
  static String register = "/auth/register/"; // done
  static String changePassword = "/auth/change-password/";
  static String logout = "/auth/logout/"; //

  static String forgotPassword = "/auth/forgot-password/"; // done
  static String resendOtp = "/auth/resend-otp/"; // done
  static String resetPassword = "/auth/reset-password/"; // done
  static String refreshToken = "/auth/token/refresh/";
  static String verifyEmail = "/auth/verify-email/"; // done
  static String checkToken = "/auth/check-token/";

  // courses
  static String allCourses = "/courses/all/";
  static String courseBySlug = "/courses/";
  static String myEnrollments = "/courses/myEnrollments/";
  static String enrollCourse = "/courses/enroll/";
  static String courseVideos(String slug) => "/courses/$slug/videos/";
  static String courseMaterials(String slug) => "/courses/$slug/materials/";
  static String videoComplete(String videoSlug) => "/video-complete/$videoSlug/";
  static String courseRating(String courseSlug) =>"/courses/rate/$courseSlug/";

  // packages
  static String allPackages = "/packages/all/";
  static String packagesBySlug = "/packages/";

  // student
  static String studentProfile(String slug) => '/students/$slug/';
  static String updateProfile(String slug) => '/students/$slug/';

  // quiz
  static String allQuizzzesByCourse(String courseSlug) =>"/courses/$courseSlug/quizzes/";
  static String quizQuestions(String quizSlug) => "/quizzes/$quizSlug/questions/";
  static String submitQuiz(String quizSlug) => "/quizzes/$quizSlug/submit/";
  static String quizResults(String quizSlug) => "/quizzes/$quizSlug/my-results/";


  // instructor
  static String instructorProfile(String slug) => '/instructors/$slug/';
}

class ApiKey {
  static String message = "message";
  static String authorization = "Authorization";
  static String firstName = "first_name";
  static String lastName = "last_name";
  static String email = "email";
  static String password = "password";
  static String role = "role";
  static String slug = "slug";
  static String isActive = "is_active";
  static String isVerified = "is_verified";
  static String student = "student";
  static String accessToken = "access";
  static String refreshToken = "refresh";
  static String user = "user";
  static String isLoggedIn = "is_logged_in";
  static String oldPassword = "old_password";
  static String newPassword = "new_password";
  static String image = "image";
  static String errors = "errors";
}
