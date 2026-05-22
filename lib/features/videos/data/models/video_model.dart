class VideoModel {
  String slug;
  String title;
  String? videoUrl;
  String? videoUpload;
  int? order;
  String? course;

  String? duration;
  bool isCompleted;
  bool isLocked;
  bool isPlaying;

  VideoModel({
    required this.slug,
    required this.title,
    this.videoUrl,
    this.videoUpload,
    this.order,
    this.course,
    this.duration = "00:00",
    this.isCompleted = false,
    this.isLocked = false,
    this.isPlaying = false,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        slug: json["slug"] ?? "",
        title: json["title"] ?? "",
        videoUrl: json["video_url"],
        videoUpload: json["video_upload"],
        order: json["order"] != null ? int.tryParse(json["order"].toString()) : null,
        course: json["course"],
        isCompleted: json["is_completed"] ?? false,
        duration: json["duration"] ?? "00:00",
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
        "video_url": videoUrl,
        "video_upload": videoUpload,
        "order": order,
        "course": course,
        "is_completed": isCompleted,
        "duration": duration,
      };
}
