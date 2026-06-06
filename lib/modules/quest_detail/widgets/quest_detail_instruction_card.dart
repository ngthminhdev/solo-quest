import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_model.dart';
import '../../../models/enums/quest_enums.dart';

class QuestDetailInstructionCard extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailInstructionCard({
    super.key,
    required this.quest,
  });

  String get _instruction {
    if (quest.instruction != null && quest.instruction!.isNotEmpty) {
      return quest.instruction!;
    }

    // Fallback based on quest type
    switch (quest.type) {
      case QuestType.water:
        return 'Uống một ly nước 250ml, chậm rãi.';
      case QuestType.breakTime:
        return 'Rời mắt khỏi màn hình, nhìn xa và thả lỏng vai.';
      case QuestType.movement:
        return 'Đi bộ nhẹ hoặc giãn cơ trong vài phút.';
      case QuestType.learning:
        return 'Tập trung học một nội dung nhỏ, tránh đa nhiệm.';
      case QuestType.sleep:
        return 'Chuẩn bị đi ngủ sớm, tắt thiết bị điện tử.';
      case QuestType.fitness:
        return 'Thực hiện bài tập thể chất nhẹ nhàng.';
      case QuestType.mindfulness:
        return 'Tập trung vào hơi thở, thả lỏng tâm trí.';
      case QuestType.review:
        return 'Ghi lại điều đã làm tốt và điều cần cải thiện.';
      case QuestType.custom:
        return 'Thực hiện nhiệm vụ theo hướng dẫn.';
    }
  }

  List<String> get _checklistItems {
    final lines = _instruction.split('\n');
    if (lines.length > 1) {
      return lines.where((l) => l.trim().isNotEmpty).toList();
    }
    return [_instruction];
  }

  @override
  Widget build(BuildContext context) {
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
                  quest.description.isNotEmpty ? quest.description : _instruction,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                    height: 1.5,
                  ),
                ),

                // Checklist if instruction has multiple lines
                if (_checklistItems.length > 1) ...[
                  const SizedBox(height: AppSpacing.s12),
                  ...(_checklistItems.map((item) => _buildChecklistItem(item))),
                ],

                // Reason
                if (quest.reason != null && quest.reason!.isNotEmpty) ...[
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
                      quest.reason!,
                      style: const TextStyle(
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
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
