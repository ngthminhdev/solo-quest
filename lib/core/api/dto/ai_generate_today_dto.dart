import '../dto/quest_dto.dart';

class AiGenerateTodayResultDto {
  final String date;
  final String mode;
  final bool inserted;
  final int generatedCount;
  final List<QuestDto> quests;

  const AiGenerateTodayResultDto({
    required this.date,
    required this.mode,
    required this.inserted,
    required this.generatedCount,
    required this.quests,
  });

  factory AiGenerateTodayResultDto.fromJson(Map<String, dynamic> json) {
    final questsRaw = json['quests'] as List<dynamic>? ?? [];
    final quests = questsRaw
        .map((q) => QuestDto.fromJson(q as Map<String, dynamic>))
        .toList();

    return AiGenerateTodayResultDto(
      date: json['date'] as String? ?? '',
      mode: json['mode'] as String? ?? 'ai',
      inserted: json['inserted'] as bool? ?? false,
      generatedCount: json['generated_count'] as int? ?? quests.length,
      quests: quests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mode': mode,
      'inserted': inserted,
      'generated_count': generatedCount,
      'quests': quests.map((q) => q.toJson()).toList(),
    };
  }
}
