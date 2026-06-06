import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklySuggestionsSection extends StatelessWidget {
  final WeeklySummaryModel summary;
  final List<bool> enabledSuggestions;
  final ValueChanged<int> onToggle;

  const WeeklySuggestionsSection({
    super.key,
    required this.summary,
    required this.enabledSuggestions,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = summary.suggestions;

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionSuggestions),
          const SizedBox(height: AppSpacing.s12),
          ...suggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final isEnabled = index < enabledSuggestions.length
                ? enabledSuggestions[index]
                : true;

            return _SuggestionCard(
              title: data.title,
              reason: data.description,
              isEnabled: isEnabled,
              onToggle: () => onToggle(index),
            );
          }),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Tính năng áp dụng tự động sẽ được thêm sau.',
            style: TextStyle(
              fontSize: 11,
              color: AppColor.fgMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      '◆ $title',
      style: const TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColor.fgMuted,
        letterSpacing: 0.06,
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;
  final String reason;
  final bool isEnabled;
  final VoidCallback onToggle;

  const _SuggestionCard({
    required this.title,
    required this.reason,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s10),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(
          color: isEnabled ? AppColor.border : AppColor.borderSubtle,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.fgSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            _ToggleSwitch(
              isOn: isEnabled,
              onTap: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _ToggleSwitch({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: isOn ? AppColor.cyan : AppColor.fgMuted,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: AppColor.bgDeep,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
