import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingBasicInfoStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onDisplayNameChanged;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onHeightChanged;
  final ValueChanged<String> onWeightChanged;

  const OnboardingBasicInfoStep({
    super.key,
    required this.data,
    required this.onDisplayNameChanged,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step1Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step1Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),

        _buildField(
          icon: RemixIcons.user_3_line,
          label: OnboardingConstants.displayNameLabel,
          child: _InputField(
            hint: OnboardingConstants.displayNameHint,
            onChanged: onDisplayNameChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.calendar_line,
          label: OnboardingConstants.ageLabel,
          child: _InputField(
            hint: OnboardingConstants.ageHint,
            suffix: OnboardingConstants.ageSuffix,
            keyboardType: TextInputType.number,
            onChanged: onAgeChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.user_3_line,
          label: OnboardingConstants.genderLabel,
          child: _DropdownField(
            value: data.gender.isEmpty ? null : data.gender,
            options: OnboardingConstants.genderOptions,
            onChanged: onGenderChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.ruler_line,
          label: OnboardingConstants.heightLabel,
          child: _InputField(
            hint: OnboardingConstants.heightHint,
            suffix: OnboardingConstants.heightSuffix,
            keyboardType: TextInputType.number,
            onChanged: onHeightChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.scales_line,
          label: OnboardingConstants.weightLabel,
          child: _InputField(
            hint: OnboardingConstants.weightHint,
            suffix: OnboardingConstants.weightSuffix,
            keyboardType: TextInputType.number,
            onChanged: onWeightChanged,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step1SystemNote,
          style: const TextStyle(
            fontFamily: 'Exo2',
            fontSize: 11,
            color: AppColor.fgMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColor.fgMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyle.captionBold.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fgSecondary,
                  letterSpacing: 0.06,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final String? suffix;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.hint,
    required this.onChanged,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 15,
                color: AppColor.fg,
                fontFamily: 'Exo2',
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColor.fgMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                suffix!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColor.fgMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColor.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColor.surface,
          style: const TextStyle(
            fontSize: 15,
            color: AppColor.fg,
            fontFamily: 'Exo2',
          ),
          icon: const Icon(
            RemixIcons.arrow_down_s_line,
            size: 18,
            color: AppColor.fgMuted,
          ),
          hint: Text(
            options.first,
            style: const TextStyle(
              fontSize: 15,
              color: AppColor.fgMuted,
              fontFamily: 'Exo2',
            ),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}
