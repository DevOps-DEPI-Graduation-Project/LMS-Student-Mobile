import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms_student/features/auth/utils/auth_validation.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/utils/get_responsive_size.dart';

class ForgotPasswordBody extends StatelessWidget {
  const ForgotPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.colorScheme.secondary,
            ),
          );

          context.go(
            AppRoutes.resetPasswordScreen,
            extra: {'email': authBloc.emailController.text.trim()},
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.colorScheme.error,
            ),
          );
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
              key: authBloc.forgetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('forgot_password_question'),
                    style: context.textTheme.displaySmall!.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('no_worries_otp'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),

                  CustomTextFormField(
                    controller: authBloc.emailController,
                    hintText: context.tr('enter_your_email'),
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    validator: (value) => validateEmail(value, context),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 32.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomPrimaryButton(
                        text: isLoading
                            ? context.tr('sending')
                            : context.tr('send_otp'),
                        onTap: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                authBloc.add(
                                  ForgotPasswordEvent(
                                    email: authBloc.emailController.text.trim(),
                                  ),
                                );
                              },
                        width: double.infinity,
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.go(AppRoutes.loginScreen),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: context.isDesktop ? 14 : 12.w,
                      ),
                      label: Text(context.tr('back_to_login')),
                      style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.onSecondary
                            .withValues(alpha: 0.5),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: context.isDesktop ? 14 : 12.sp,
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
