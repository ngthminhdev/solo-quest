import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

enum PreferredDifficulty {
  beginner,
  intermediate,
  advanced,
  any,
}

class RoadmapPreferences {
  final String? category;
  final PreferredDifficulty difficulty;
  final int? maxDuration; // in minutes
  final String? learningGoal;

  RoadmapPreferences({
    this.category,
    this.difficulty = PreferredDifficulty.any,
    this.maxDuration,
    this.learningGoal,
  });

  RoadmapPreferences copyWith({
    String? category,
    PreferredDifficulty? difficulty,
    int? maxDuration,
    String? learningGoal,
  }) {
    return RoadmapPreferences(
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      maxDuration: maxDuration ?? this.maxDuration,
      learningGoal: learningGoal ?? this.learningGoal,
    );
  }
}

class RoadmapPreferenceSheet extends StatefulWidget {
  final Function(RoadmapPreferences preferences) onSubmit;

  const RoadmapPreferenceSheet({
    super.key,
    required this.onSubmit,
  });

  static Future<RoadmapPreferences?> show(
    BuildContext context, {
    required Function(RoadmapPreferences preferences) onSubmit,
  }) {
    return showModalBottomSheet<RoadmapPreferences>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => RoadmapPreferenceSheet(
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RoadmapPreferenceSheet> createState() => _RoadmapPreferenceSheetState();
}

class _RoadmapPreferenceSheetState extends State<RoadmapPreferenceSheet> {
  String? _selectedCategory;
  PreferredDifficulty _selectedDifficulty = PreferredDifficulty.any;
  int? _selectedDuration;
  final TextEditingController _goalController = TextEditingController();

  // Mock categories - should come from backend or constants
  final List<String> _categories = [
    'Backend',
    'Frontend',
    'DevOps',
    'Database',
    'Cloud',
    'English',
  ];

  final List<int> _durationOptions = [60, 120, 180, 240, 300];

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bg,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.s12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColor.secondaryToPrimaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    RemixIcons.sparkling_2_fill,
                    size: 22,
                    color: AppColor.bgDeep,
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn lộ trình học',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.fg,
                        ),
                      ),
                      SizedBox(height: AppSpacing.s2),
                      Text(
                        'Tìm lộ trình phù hợp với mục tiêu của bạn',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(RemixIcons.close_line),
                  color: AppColor.fgMuted,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColor.border),

          // Form content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.s20,
                right: AppSpacing.s20,
                top: AppSpacing.s20,
                bottom: keyboardHeight + AppSpacing.s20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Learning goal input
                  _buildSectionLabel('Bạn muốn học gì?', isRequired: true),
                  const SizedBox(height: AppSpacing.s10),
                  TextField(
                    controller: _goalController,
                    decoration: InputDecoration(
                      hintText: 'Ví dụ: State Management, Testing, Performance...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColor.fgMuted,
                      ),
                      filled: true,
                      fillColor: AppColor.bgRaised,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(color: AppColor.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(color: AppColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(color: AppColor.cyan, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.fg,
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: AppSpacing.s24),

                  // Category selector
                  _buildSectionLabel('Chủ đề'),
                  const SizedBox(height: AppSpacing.s10),
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return _CategoryChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedCategory = isSelected ? null : category;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.s24),

                  // Difficulty selector
                  _buildSectionLabel('Độ khó'),
                  const SizedBox(height: AppSpacing.s10),
                  _buildDifficultySelector(),

                  const SizedBox(height: AppSpacing.s24),

                  // Duration selector
                  _buildSectionLabel('Thời lượng tối đa'),
                  const SizedBox(height: AppSpacing.s10),
                  Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: [
                      ..._durationOptions.map((duration) {
                        final isSelected = _selectedDuration == duration;
                        return _DurationChip(
                          label: '${duration ~/ 60}h',
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedDuration = isSelected ? null : duration;
                            });
                          },
                        );
                      }),
                      _DurationChip(
                        label: 'Bất kỳ',
                        isSelected: _selectedDuration == null,
                        onTap: () {
                          setState(() {
                            _selectedDuration = null;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: const BoxDecoration(
              color: AppColor.bg,
              border: Border(
                top: BorderSide(color: AppColor.border),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goalController.text.trim().isEmpty
                      ? null
                      : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.cyan,
                    foregroundColor: AppColor.bgDeep,
                    disabledBackgroundColor: AppColor.bgRaised,
                    disabledForegroundColor: AppColor.fgMuted,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(RemixIcons.search_line, size: 18),
                      SizedBox(width: AppSpacing.s8),
                      Text(
                        'Tìm lộ trình phù hợp',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.fg,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: AppSpacing.s4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.danger,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      children: [
        _DifficultyOption(
          difficulty: PreferredDifficulty.any,
          label: 'Bất kỳ',
          description: 'Hiển thị tất cả các độ khó',
          icon: RemixIcons.star_line,
          isSelected: _selectedDifficulty == PreferredDifficulty.any,
          onTap: () => setState(() => _selectedDifficulty = PreferredDifficulty.any),
        ),
        const SizedBox(height: AppSpacing.s8),
        _DifficultyOption(
          difficulty: PreferredDifficulty.beginner,
          label: 'Cơ bản',
          description: 'Bắt đầu từ nền tảng',
          icon: RemixIcons.seedling_line,
          color: AppColor.success,
          isSelected: _selectedDifficulty == PreferredDifficulty.beginner,
          onTap: () => setState(() => _selectedDifficulty = PreferredDifficulty.beginner),
        ),
        const SizedBox(height: AppSpacing.s8),
        _DifficultyOption(
          difficulty: PreferredDifficulty.intermediate,
          label: 'Trung bình',
          description: 'Đã có kiến thức cơ bản',
          icon: RemixIcons.arrow_up_line,
          color: AppColor.warn,
          isSelected: _selectedDifficulty == PreferredDifficulty.intermediate,
          onTap: () => setState(() => _selectedDifficulty = PreferredDifficulty.intermediate),
        ),
        const SizedBox(height: AppSpacing.s8),
        _DifficultyOption(
          difficulty: PreferredDifficulty.advanced,
          label: 'Nâng cao',
          description: 'Thử thách nâng cao kỹ năng',
          icon: RemixIcons.rocket_line,
          color: AppColor.danger,
          isSelected: _selectedDifficulty == PreferredDifficulty.advanced,
          onTap: () => setState(() => _selectedDifficulty = PreferredDifficulty.advanced),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final preferences = RoadmapPreferences(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      maxDuration: _selectedDuration,
      learningGoal: _goalController.text.trim(),
    );

    widget.onSubmit(preferences);
    Navigator.pop(context, preferences);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyan : AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.bgDeep : AppColor.fg,
          ),
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyan : AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.bgDeep : AppColor.fg,
          ),
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final PreferredDifficulty difficulty;
  final String label;
  final String description;
  final IconData icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.difficulty,
    required this.label,
    required this.description,
    required this.icon,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColor.fgMuted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: effectiveColor,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fg,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                RemixIcons.check_line,
                size: 20,
                color: AppColor.cyan,
              ),
          ],
        ),
      ),
    );
  }
}
