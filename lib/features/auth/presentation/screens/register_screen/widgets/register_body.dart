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

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('verification_code_sent')),
              backgroundColor: context.colorScheme.secondary,
            ),
          );

          context.go(
            AppRoutes.verifyOtpScreen,
            extra: {
              'email': authBloc.emailController.text.trim(),
              'source': 'register',
            },
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
              maxWidth: context.isDesktop ? 500 : 400.w,
            ),
            child: Form(
              key: authBloc.registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.tr('start_your_journey'),
                    style: context.textTheme.displaySmall!.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('start_learning_journey_today'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),

                  const AuthToggleSwitch(isLogin: false),

                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: authBloc.firstNameController,
                          hintText: context.tr('first_name'),
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            size: context.isDesktop ? 22 : 22.w,
                          ),
                          validator: (value) => validateFirstName(value, context),
                        ),
                      ),

                      SizedBox(width: context.isDesktop ? 16 : 15.w),
                      Expanded(
                        child: CustomTextFormField(
                          controller: authBloc.lastNameController,
                          hintText: context.tr('last_name'),
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            size: context.isDesktop ? 22 : 22.w,
                          ),
                          validator: (value) => validateLastName(value, context),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: authBloc.emailController,
                    hintText: context.tr('email_address'),
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                      size: context.isDesktop ? 22 : 22.w,
                    ),
                    validator: (value) => validateEmail(value, context),
                    keyboardType: TextInputType.emailAddress,
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
                    validator: (value) => validatePassword(value, context),
                  ),

                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: authBloc.confirmPasswordController,
                    hintText: context.tr('confirm_password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: context.isDesktop ? 22 : 22.w,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('please_confirm_password');
                      }
                      if (value != authBloc.passwordController.text) {
                        return context.tr('passwords_do_not_match');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return CustomPrimaryButton(
                        text: isLoading
                            ? context.tr('creating_account')
                            : context.tr('create_account'),
                        onTap: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                context.read<AuthBloc>().add(RegisterEvent());
                              },
                        width: double.infinity,
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.loginScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: context.tr('already_have_account'),
                          style: context.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: context.tr('sign_in'),
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
