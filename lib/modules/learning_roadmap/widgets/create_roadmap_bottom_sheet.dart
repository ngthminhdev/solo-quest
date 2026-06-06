import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import 'roadmap_suggestion_card.dart';

class CreateRoadmapBottomSheet extends StatefulWidget {
  final Function(String suggestionId) onCreateRoadmap;
  final List<RoadmapSuggestion> suggestions;
  final bool isLoadingSuggestions;

  const CreateRoadmapBottomSheet({
    super.key,
    required this.onCreateRoadmap,
    required this.suggestions,
    this.isLoadingSuggestions = false,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(String suggestionId) onCreateRoadmap,
    required List<RoadmapSuggestion> suggestions,
    bool isLoadingSuggestions = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => CreateRoadmapBottomSheet(
        onCreateRoadmap: onCreateRoadmap,
        suggestions: suggestions,
        isLoadingSuggestions: isLoadingSuggestions,
      ),
    );
  }

  @override
  State<CreateRoadmapBottomSheet> createState() => _CreateRoadmapBottomSheetState();
}

class _CreateRoadmapBottomSheetState extends State<CreateRoadmapBottomSheet> {
  String? _selectedSuggestionId;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.85;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
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
                        'Chọn lộ trình phù hợp với mục tiêu của bạn',
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

          // Content
          Flexible(
            child: widget.isLoadingSuggestions
                ? _buildLoadingState()
                : widget.suggestions.isEmpty
                    ? _buildEmptyState()
                    : _buildSuggestionsList(),
          ),

          // Action bar
          if (!widget.isLoadingSuggestions && widget.suggestions.isNotEmpty)
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
                    onPressed: _selectedSuggestionId != null
                        ? () {
                            widget.onCreateRoadmap(_selectedSuggestionId!);
                            Navigator.pop(context);
                          }
                        : null,
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
                    child: const Text(
                      'Tạo lộ trình này',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.s40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.cyan),
            ),
            SizedBox(height: AppSpacing.s16),
            Text(
              'Đang tìm lộ trình phù hợp...',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              RemixIcons.file_list_3_line,
              size: 48,
              color: AppColor.fgMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            const Text(
              'Không tìm thấy lộ trình',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            const Text(
              'Chưa có lộ trình phù hợp với bộ lọc.\nVui lòng thử lại với điều kiện khác.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fgSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s16),
      itemCount: widget.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = widget.suggestions[index];
        final isSelected = _selectedSuggestionId == suggestion.id;

        return RoadmapSuggestionCard(
          suggestion: suggestion,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedSuggestionId = isSelected ? null : suggestion.id;
            });
          },
        );
      },
    );
  }
}
