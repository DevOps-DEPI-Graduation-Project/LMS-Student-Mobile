import 'package:flutter/material.dart';
import 'package:lms_student/core/localization/app_localizations.dart';

String? validateEmail(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return context.tr('val_email_required');
  }
  final email = value.trim();
  if (email.length < 5) {
    return context.tr('val_email_min_length');
  }
  if (email.length > 50) {
    return context.tr('val_email_max_length');
  }
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );
  if (!emailRegex.hasMatch(email)) {
    return context.tr('val_email_invalid');
  }
  if (email.contains('..')) {
    return context.tr('val_email_consecutive_dots');
  }
  if (email.startsWith('.') || email.endsWith('.')) {
    return context.tr('val_email_dot_position');
  }
  final parts = email.split('@');
  if (parts.length != 2) {
    return context.tr('val_email_one_at');
  }
  final domain = parts[1];
  if (!domain.contains('.')) {
    return context.tr('val_email_domain_dot');
  }
  if (domain.startsWith('.') || domain.endsWith('.')) {
    return context.tr('val_email_domain_dot_position');
  }
  return null;
}

String? validateFirstName(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return context.tr('val_first_name_required');
  }
  final firstName = value.trim();
  if (firstName.length < 2) {
    return context.tr('val_first_name_min_length');
  }
  if (firstName.length > 30) {
    return context.tr('val_first_name_max_length');
  }
  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  if (!nameRegex.hasMatch(firstName)) {
    return context.tr('val_first_name_letters_only');
  }
  if (firstName.startsWith(' ') || firstName.endsWith(' ')) {
    return context.tr('val_first_name_space_position');
  }
  if (firstName.contains(RegExp(r'\s{2,}'))) {
    return context.tr('val_first_name_consecutive_spaces');
  }
  return null;
}

String? validateLastName(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return context.tr('val_last_name_required');
  }
  final lastName = value.trim();
  if (lastName.length < 2) {
    return context.tr('val_last_name_min_length');
  }
  if (lastName.length > 30) {
    return context.tr('val_last_name_max_length');
  }
  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  if (!nameRegex.hasMatch(lastName)) {
    return context.tr('val_last_name_letters_only');
  }
  if (lastName.startsWith(' ') || lastName.endsWith(' ')) {
    return context.tr('val_last_name_space_position');
  }
  if (lastName.contains(RegExp(r'\s{2,}'))) {
    return context.tr('val_last_name_consecutive_spaces');
  }
  return null;
}

String? validatePassword(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return context.tr('val_password_required');
  }
  if (value.length < 8) {
    return context.tr('val_password_min_length');
  }
  if (value.length > 32) {
    return context.tr('val_password_max_length');
  }
  final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,32}$',
  );
  if (!passwordRegex.hasMatch(value)) {
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return context.tr('val_password_uppercase');
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return context.tr('val_password_lowercase');
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return context.tr('val_password_number');
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return context.tr('val_password_special');
    }
    return context.tr('val_password_format');
  }
  return null;
}
