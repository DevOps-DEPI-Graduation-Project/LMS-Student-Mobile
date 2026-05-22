import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms_student/features/auth/presentation/screens/widgets/auth_toggle_switch.dart';
import 'package:lms_student/features/auth/utils/auth_validation.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/utils/get_responsive_size.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('login_success')),
              backgroundColor: context.colorScheme.secondary,
            ),
          );
          context.go(AppRoutes.rootAfterLogin);
        } else if (state is AuthError) {
          final errorMsg = state.message.toLowerCase();
          if (errorMsg.contains('verify') || errorMsg.contains('verified')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('verify_email_resend_otp')),
                backgroundColor: context.colorScheme.primary,
                duration: const Duration(seconds: 4),
              ),
            );
            context.pushNamed(
              AppRoutes.verifyOtpScreen,
              extra: {'email': authBloc.emailController.text},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.isDesktop ? 80 : 36.w,
            vertical: context.isDesktop ? 80 : 56.h,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isDesktop ? 450 : 400.w,
            ),
            child: Form(
              key: authBloc.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('welcome_back'),
                    style: context.textTheme.displaySmall!.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('good_to_see_you_again'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),

                  const AuthToggleSwitch(isLogin: true),

                  SizedBox(height: 32.h),
                  CustomTextFormField(
                    controller: authBloc.emailController,
                    hintText: context.tr('email_address'),
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => validateEmail(value, context),
                  ),

                  SizedBox(height: 16.h),

                  CustomTextFormField(
                    controller: authBloc.passwordController,
                    hintText: context.tr('password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: context.isDesktop ? 22 : 22.w,
                    ),
                    // validator: (value) => validatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRoutes.forgotPasswordScreen);
                      },
                      child: Text(
                        context.tr('forgot_password_question'),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return CustomPrimaryButton(
                        text: isLoading
                            ? context.tr('signing_in')
                            : context.tr('sign_in'),
                        onTap: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                context.read<AuthBloc>().add(LoginEvent());
                              },
                        width: double.infinity,
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.registerScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: context.tr('dont_have_account'),
                          style: context.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: context.tr('sign_up'),
                              style: TextStyle(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.rootBeforeLogin),
                      child: Text(
                        context.tr('continue_as_guest'),
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
