import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_goal_model.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../widgets/app_button/app_button.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalProgressSheet {
  static Future<double?> show(
    BuildContext context, {
    required LearningGoalModel goal,
  }) async {
    return await AppBottomSheet.show<double>(
      context: context,
      title: LearningGoalsConstants.progressSheetTitle,
      body: _LearningGoalProgressForm(goal: goal),
    );
  }
}

class _LearningGoalProgressForm extends StatefulWidget {
  final LearningGoalModel goal;

  const _LearningGoalProgressForm({required this.goal});

  @override
  State<_LearningGoalProgressForm> createState() =>
      _LearningGoalProgressFormState();
}

class _LearningGoalProgressFormState
    extends State<_LearningGoalProgressForm> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.goal.progress;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal title
          Text(
            widget.goal.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
          ),

          const SizedBox(height: AppSpacing.s20),

          // Progress percentage
          Center(
            child: Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColor.cyan,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColor.cyan,
              inactiveTrackColor: AppColor.surface,
              thumbColor: AppColor.cyan,
              overlayColor: AppColor.cyan.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _progress,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
              },
            ),
          ),

          const SizedBox(height: AppSpacing.s8),

          // Min/Max labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.fgMuted,
                ),
              ),
              Text(
                '100%',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s24),

          // Submit button
          AppButton(
            label: LearningGoalsConstants.progressSheetButton,
            onPressed: _handleSubmit,
            variant: AppButtonVariant.primary,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    Navigator.of(context).pop(_progress);
  }
}
