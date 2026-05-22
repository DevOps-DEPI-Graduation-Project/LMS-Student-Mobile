import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_student/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:lms_student/features/splash/presentation/bloc/splash_event.dart';
import 'package:lms_student/features/splash/presentation/bloc/splash_state.dart';
import 'package:lms_student/features/splash/presentation/screens/widgets/custom_error_popup.dart';
import 'package:lms_student/core/theme/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Start with data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SplashBloc>().add(SplashStarted());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashLoaded || state is SplashError) {
          final timeSinceStart = DateTime.now()
              .difference(_startTime)
              .inMilliseconds;
          // Ensure a minimum splash duration of 3 seconds for better UX
          final remainingDelay = (3000 - timeSinceStart).clamp(0, 3000);

          Future.delayed(Duration(milliseconds: remainingDelay), () {
            if (mounted) _handleNavigation(context, state);
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            // Top Right Decorative Circle
            Positioned(
              top: -150.h,
              right: -100.w,
              child: Container(
                width: 450.w,
                height: 450.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.18),
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Left Decorative Circle
            Positioned(
              bottom: -200.h,
              left: -150.w,
              child: Container(
                width: 600.w,
                height: 600.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.secondary.withValues(alpha: 0.15),
                      theme.colorScheme.secondary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Center Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 170.r,
                        height: 170.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        context.colorScheme.surface.withValues(
                                          alpha: 0.7,
                                        ),
                                        context.colorScheme.surface.withValues(
                                          alpha: 0.3,
                                        ),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: context.colorScheme.surface,
                                      width: 1.5.r,
                                    ),
                                  ),
                                ),
                              ),
                              // Logo
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(35.r),
                                  child: Image.asset(
                                    AppAssets.appLogoPng,
                                    width: 100.r,
                                    height: 100.r,
                                    cacheHeight: 300,
                                    cacheWidth: 300,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 48.h),
                      // Main Title
                      Text(
                        context.tr('commit_ma3ana'),
                        style: context.textTheme.displaySmall!.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0.sp,
                          fontSize: 28.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Subtitle
                      Text(
                        context.tr('commit_ma3ana_build_consistency'),
                        style: context.textTheme.labelMedium!.copyWith(
                          color: context.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                          letterSpacing: 1.5.sp,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, SplashState state) {
    if (state is SplashLoaded) {
      context.go(AppRoutes.rootAfterLogin);
    } else if (state is SplashError) {
      if (state.message != null &&
          state.message != "No token found" &&
          state.message != "Session expired" &&
          state.message!.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomErrorPopup(
            title: context.tr('error'),
            message: state.message!,
            onRetry: () {
              context.pop();
              context.read<SplashBloc>().add(SplashStarted());
            },
          ),
        );
      } else {
        // String msg = context.tr('authentication_failed');
        // if (state.message == "No token found") {
        //   msg = context.tr('no_token_found');
        // } else if (state.message == "Session expired") {
        //   msg = context.tr('session_expired');
        // } else if (state.isActive == false) {
        //   msg = context.tr('account_inactive');
        // } else if (state.isVerified == false) {
        //   msg = context.tr('account_unverified');
        // }

        // if (msg != context.tr('authentication_failed')) {
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text(msg)));
        // }
        context.go(AppRoutes.loginScreen);
      }
    }
  }
}
