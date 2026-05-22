import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_student/core/extensions/context_extensions.dart';
import 'package:lms_student/core/localization/app_localizations.dart';
import 'package:lms_student/core/utils/get_responsive_size.dart';
import 'package:lms_student/features/auth/utils/auth_validation.dart';
import 'package:lms_student/features/widgets/custom_primary_button.dart';
import 'package:lms_student/features/widgets/custom_text_form_field.dart';
import 'package:lms_student/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lms_student/features/profile/data/model/change_password_model.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveValue(
      mobile: 18.w,
      tablet: 18,
      desktop: 22,
    );
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('password_changed_successfully')),
              backgroundColor: context.colorScheme.secondary,
            ),
          );
          context.pop();
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 64.h),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 40.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.05,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.tr('change_password'),
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.tr('update_security_desc'),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomTextFormField(
                          controller: _oldPasswordController,
                          hintText: context.tr('old_password'),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: iconSize,
                          ),
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr('required');
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 24.h),
                        CustomTextFormField(
                          controller: _newPasswordController,
                          hintText: context.tr('new_password'),
                          prefixIcon: Icon(Icons.key_rounded, size: iconSize),
                          isPassword: true,
                          validator: (value) =>
                              validatePassword(value, context),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 24.h),
                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          hintText: context.tr('confirm_new_password'),
                          prefixIcon: Icon(
                            Icons.done_all_rounded,
                            size: iconSize,
                          ),
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr('required');
                            }
                            if (value != _newPasswordController.text) {
                              return context.tr('passwords_do_not_match');
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 40.h),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            final isLoading = state is ProfileLoading;
                            return CustomPrimaryButton(
                              text: isLoading
                                  ? context.tr('updating')
                                  : context.tr('update_password'),
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        context.read<ProfileBloc>().add(
                                          ChangePasswordEvent(
                                            request: ChangePasswordModel(
                                              oldPassword:
                                                  _oldPasswordController.text,
                                              newPassword:
                                                  _newPasswordController.text,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              width: double.infinity,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
