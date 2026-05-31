import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../models/schedule_model.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import '../constants/schedule_editor_constants.dart';
import 'schedule_block_card.dart';
import 'schedule_empty_view.dart';

class ScheduleBlockListSection extends StatelessWidget {
  final List<ScheduleBlockModel> blocks;
  final ValueChanged<ScheduleBlockModel> onEdit;
  final ValueChanged<ScheduleBlockModel> onDelete;

  const ScheduleBlockListSection({
    super.key,
    required this.blocks,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) {
      return const ScheduleEmptyView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppSectionHeader(title: ScheduleEditorConstants.sectionTitle),
        ),
        const SizedBox(height: AppSpacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          itemCount: blocks.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s10),
          itemBuilder: (context, index) {
            final block = blocks[index];
            return ScheduleBlockCard(
              block: block,
              onEdit: () => onEdit(block),
              onDelete: () => onDelete(block),
            );
          },
        ),
      ],
    );
  }
}
