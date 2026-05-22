import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/routing/app_routes.dart';
import 'package:lms_student/features/auth/data/model/reset_password_request_model.dart';
import 'package:lms_student/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lms_student/features/auth/utils/auth_validation.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/utils/get_responsive_size.dart';

class ResetPasswordBody extends StatelessWidget {
  final String email;
  const ResetPasswordBody({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('password_reset_success')),
              backgroundColor: context.colorScheme.secondary,
            ),
          );
          authBloc.clearResetPasswordControllers();
          authBloc.clearOtpControllers();
          context.go(AppRoutes.loginScreen);
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
              key: authBloc.resetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('create_new_password'),
                    style: context.textTheme.displaySmall!.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('new_password_must_be_different'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),

                  Text(
                    context.tr('verification_code'),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => _buildOtpBox(context, index, authBloc),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  CustomTextFormField(
                    controller: authBloc.newPasswordController,
                    hintText: context.tr('new_password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    validator: (value) => validatePassword(value, context),
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: 16.h),

                  CustomTextFormField(
                    controller: authBloc.confirmNewPasswordController,
                    hintText: context.tr('confirm_new_password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_reset_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('please_confirm_password');
                      }
                      if (value != authBloc.newPasswordController.text) {
                        return context.tr('passwords_do_not_match');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: 32.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomPrimaryButton(
                        text: isLoading
                            ? context.tr('updating')
                            : context.tr('update_password'),
                        onTap: isLoading
                            ? null
                            : () {
                                final otpCode = authBloc.getOtpCode();
                                if (otpCode.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.tr('please_enter_full_otp'),
                                      ),
                                      backgroundColor:
                                          context.colorScheme.error,
                                    ),
                                  );
                                  return;
                                }
                                authBloc.otpController.text = otpCode;

                                if (authBloc.resetPasswordFormKey.currentState!
                                    .validate()) {
                                  authBloc.add(
                                    ResetPasswordEvent(
                                      requestModel: ResetPasswordRequestModel(
                                        otp: authBloc.otpController.text.trim(),
                                        newPassword: authBloc
                                            .newPasswordController
                                            .text
                                            .trim(),
                                      ),
                                    ),
                                  );
                                }
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
                        size: context.isDesktop ? 22 : 18.w,
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

  Widget _buildOtpBox(BuildContext context, int index, AuthBloc authBloc) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.isDesktop ? 8 : 4.w),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: authBloc.otpControllers[index],
              onChanged: (value) {
                if (value.length == 1 && index < 5) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: context.colorScheme.secondary.withValues(
                  alpha: 0.03,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: context.colorScheme.secondary.withValues(
                      alpha: 0.15,
                    ),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: context.colorScheme.secondary,
                    width: 2.5,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
