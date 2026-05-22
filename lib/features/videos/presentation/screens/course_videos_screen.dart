import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:lms_student/features/videos/presentation/bloc/videos_event.dart';
import 'package:lms_student/features/videos/presentation/bloc/videos_state.dart';
import 'package:lms_student/features/videos/presentation/widgets/custom_video_player.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/videos/data/models/video_model.dart';
import 'package:lms_student/features/videos/presentation/widgets/custom_course_videos_item.dart';
import 'package:lms_student/features/videos/utils/video_duration_utils.dart';
import 'package:lms_student/features/widgets/loading_indicator_widget.dart';
import 'package:lms_student/features/widgets/empty_state_widget.dart';
import 'package:lms_student/features/widgets/error_feedback_widget.dart';

class CourseVideosScreen extends StatefulWidget {
  final String slug;

  const CourseVideosScreen({super.key, required this.slug});

  @override
  State<CourseVideosScreen> createState() => _CourseVideosScreenState();
}

class _CourseVideosScreenState extends State<CourseVideosScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<VideosBloc>().add(GetCourseVideos(slug: widget.slug));
  }

  void playVideo(int index, List<VideoModel> videos) {
    context.read<VideosBloc>().add(PlayVideoEvent(index: index));
    setState(() {
      currentIndex = index;
    });
  }

  void nextVideo(List<VideoModel> videos) {
    if (currentIndex < videos.length - 1) {
      playVideo(currentIndex + 1, videos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("course_videos")),
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: BlocBuilder<VideosBloc, VideosState>(
          builder: (context, state) {
            if (state is VideosLoading) {
              return const Center(child: LoadingIndicatorWidget());
            } else if (state is VideosError) {
              return ErrorFeedbackWidget(
                errorMessage: state.message,
                onRetry: () {
                  context.read<VideosBloc>().add(
                    GetCourseVideos(slug: widget.slug),
                  );
                },
              );
            } else if (state is VideosLoaded) {
              if (state.videos.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.video_library_outlined,
                  title: context.tr('no_videos_found'),
                );
              }

              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomVideoPlayer(
                      video: state.videos[currentIndex],
                      onVideoEnded: () {
                        context.read<VideosBloc>().add(
                          WatchedVideoEvent(
                            courseSlug: widget.slug,
                            videoSlug: state.videos[currentIndex].slug,
                            duration:
                                parseDurationToSeconds(
                                  state.videos[currentIndex].duration,
                                ) +
                                200,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.videos[currentIndex].title,
                                  style: context.textTheme.headlineMedium,
                                ),
                                SizedBox(height: 16.h),
                                Center(
                                  child: CustomPrimaryButton(
                                    text: context.tr("next_lesson"),
                                    suffixIcon: const Icon(Icons.arrow_forward),
                                    onTap: () => nextVideo(state.videos),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return CustomCourseVideosItem(
                              video: state.videos[index],
                              onTap: () => playVideo(index, state.videos),
                            );
                          }, childCount: state.videos.length),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
