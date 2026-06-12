import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_model.dart';

class QuestDetailInstructionCard extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailInstructionCard({super.key, required this.quest});

  String? get _instruction {
    final instruction = quest.instruction?.trim();
    if (instruction != null && instruction.isNotEmpty) {
      return instruction;
    }
    return null;
  }

  String get _missionText {
    final description = quest.description.trim();
    if (description.isNotEmpty) {
      return description;
    }
    return _instruction ?? 'Thực hiện nhiệm vụ theo hướng dẫn.';
  }

  List<String> get _checklistItems {
    final instruction = _instruction;
    if (instruction == null) {
      return const [];
    }

    final lines = instruction.split('\n');
    if (lines.length > 1) {
      return lines.where((l) => l.trim().isNotEmpty).toList();
    }
    return [instruction];
  }

  @override
  Widget build(BuildContext context) {
    final instruction = _instruction;
    final checklistItems = _checklistItems;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Nhiệm Vụ',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),

          // Mission card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColor.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission action
                Text(
                  _missionText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                    height: 1.5,
                  ),
                ),

                // Checklist if instruction has multiple lines
                if (checklistItems.length > 1) ...[
                  const SizedBox(height: AppSpacing.s12),
                  ...(checklistItems.map((item) => _buildChecklistItem(item))),
                ],

                // Instruction
                if (instruction != null) ...[
                  const SizedBox(height: AppSpacing.s12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: AppSpacing.s12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.borderSubtle),
                      ),
                    ),
                    child: Text(
                      instruction,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.fgSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColor.fgMuted, width: 2),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: AppColor.fg),
            ),
          ),
        ],
      ),
    );
  }
}
