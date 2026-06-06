import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
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
    final l10n = context.l10n;

    final genderOptions = [
      OnboardingStepOption('male', l10n.onboardingStep1GenderMale),
      OnboardingStepOption('female', l10n.onboardingStep1GenderFemale),
      OnboardingStepOption('other', l10n.onboardingStep1GenderOther),
    ];
    final genderValue = genderOptions.any((option) => option.key == data.gender)
        ? data.gender
        : 'male';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep1Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep1Subtitle,
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
          label: l10n.onboardingStep1NameLabel,
          child: _InputField(
            hint: l10n.onboardingStep1NameHint,
            initialValue: data.displayName,
            onChanged: onDisplayNameChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.calendar_line,
          label: l10n.onboardingStep1AgeLabel,
          child: _InputField(
            hint: l10n.onboardingStep1AgeHint,
            suffix: l10n.onboardingStep1AgeSuffix,
            keyboardType: TextInputType.number,
            onChanged: onAgeChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.user_3_line,
          label: l10n.onboardingStep1GenderLabel,
          child: _DropdownField(
            value: genderValue,
            options: genderOptions,
            onChanged: onGenderChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.ruler_line,
          label: l10n.onboardingStep1HeightLabel,
          child: _InputField(
            hint: l10n.onboardingStep1HeightHint,
            suffix: l10n.onboardingStep1HeightSuffix,
            keyboardType: TextInputType.number,
            onChanged: onHeightChanged,
          ),
        ),

        _buildField(
          icon: RemixIcons.scales_line,
          label: l10n.onboardingStep1WeightLabel,
          child: _InputField(
            hint: l10n.onboardingStep1WeightHint,
            suffix: l10n.onboardingStep1WeightSuffix,
            keyboardType: TextInputType.number,
            onChanged: onWeightChanged,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep1SystemNote,
          style: const TextStyle(
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

class _InputField extends StatefulWidget {
  final String hint;
  final String? suffix;
  final String? initialValue;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.hint,
    required this.onChanged,
    this.suffix,
    this.initialValue,
    this.keyboardType,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              controller: _controller,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              style: const TextStyle(fontSize: 15, color: AppColor.fg),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppColor.fgMuted),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (widget.suffix != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                widget.suffix!,
                style: const TextStyle(fontSize: 13, color: AppColor.fgMuted),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final List<OnboardingStepOption> options;
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
          style: const TextStyle(fontSize: 15, color: AppColor.fg),
          icon: const Icon(
            RemixIcons.arrow_down_s_line,
            size: 18,
            color: AppColor.fgMuted,
          ),
          hint: options.isNotEmpty
              ? Text(
                  options.first.label,
                  style: const TextStyle(fontSize: 15, color: AppColor.fgMuted),
                )
              : null,
          items: options.map((OnboardingStepOption option) {
            return DropdownMenuItem<String>(
              value: option.key,
              child: Text(option.label),
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
