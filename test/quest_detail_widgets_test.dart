import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:solo_quest/models/quest_model.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/modules/quest_detail/widgets/quest_detail_header.dart';
import 'package:solo_quest/modules/quest_detail/widgets/quest_detail_status_card.dart';
import 'package:solo_quest/modules/quest_detail/widgets/quest_detail_action_bar.dart';
import 'package:solo_quest/modules/quest_detail/widgets/quest_detail_instruction_card.dart';

void main() {
  group('Quest Detail Widget Tests', () {
    late QuestModel completedQuest;
    late QuestModel snoozedQuest;
    late QuestModel pendingQuest;
    late QuestModel inProgressQuest;

    setUp(() {
      final now = DateTime.now();

      completedQuest = QuestModel(
        id: 'quest_completed',
        title: 'Completed Quest',
        description: 'This quest is completed',
        type: QuestType.water,
        status: QuestStatus.completed,
        exp: 20,
        estimatedMinutes: 5,
        completedAt: now.subtract(const Duration(hours: 1)),
        reason: 'Test reason for completed quest',
        instruction: 'Test instruction',
      );

      snoozedQuest = QuestModel(
        id: 'quest_snoozed',
        title: 'Snoozed Quest',
        description: 'This quest is snoozed',
        type: QuestType.breakTime,
        status: QuestStatus.snoozed,
        exp: 15,
        estimatedMinutes: 10,
        snoozedUntil: now.add(const Duration(minutes: 30)),
        reason: 'Test reason for snoozed quest',
        instruction: 'Test instruction',
      );

      pendingQuest = QuestModel(
        id: 'quest_pending',
        title: 'Pending Quest',
        description: 'This quest is pending',
        type: QuestType.movement,
        status: QuestStatus.pending,
        exp: 25,
        estimatedMinutes: 15,
        dueDate: now.add(const Duration(hours: 2)),
        reason: 'Test reason for pending quest',
        instruction: 'Test instruction',
      );

      inProgressQuest = QuestModel(
        id: 'quest_active',
        title: 'In Progress Quest',
        description: 'This quest is active',
        type: QuestType.learning,
        status: QuestStatus.active,
        exp: 30,
        estimatedMinutes: 20,
        startedAt: now.subtract(const Duration(minutes: 5)),
        reason: 'Test reason for active quest',
        instruction: 'Test instruction',
      );
    });

    testWidgets('QuestDetailHeader shows completed status correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailHeader(quest: completedQuest),
          ),
        ),
      );

      // Verify title is shown
      expect(find.text('Completed Quest'), findsOneWidget);

      // Verify status badge shows completed
      expect(find.text('✓ Đã xong'), findsOneWidget);
    });

    testWidgets('QuestDetailHeader shows snoozed status correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailHeader(quest: snoozedQuest),
          ),
        ),
      );

      expect(find.text('Snoozed Quest'), findsOneWidget);
      expect(find.text('◷ Đã hoãn'), findsOneWidget);
    });

    testWidgets('QuestDetailHeader shows pending status correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailHeader(quest: pendingQuest),
          ),
        ),
      );

      expect(find.text('Pending Quest'), findsOneWidget);
      expect(find.text('● Cần làm'), findsOneWidget);
    });

    testWidgets('QuestDetailStatusCard shows completed time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailStatusCard(quest: completedQuest),
          ),
        ),
      );

      // Verify EXP is shown
      expect(find.text('+20 EXP'), findsOneWidget);

      // Verify estimated time is shown
      expect(find.text('5 phút'), findsOneWidget);

      // Verify completed time is shown
      expect(find.textContaining('Hoàn thành lúc'), findsOneWidget);

      // Verify no "--:--" placeholder
      expect(find.text('--:--'), findsNothing);
    });

    testWidgets('QuestDetailStatusCard shows snoozed_until time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailStatusCard(quest: snoozedQuest),
          ),
        ),
      );

      // Verify snoozed time is shown
      expect(find.textContaining('Hoãn đến'), findsOneWidget);

      // Verify no "--:--" placeholder
      expect(find.text('--:--'), findsNothing);
    });

    testWidgets('QuestDetailStatusCard shows due_date time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailStatusCard(quest: pendingQuest),
          ),
        ),
      );

      // Verify due date is shown
      expect(find.textContaining('Hạn'), findsOneWidget);

      // Verify no "--:--" placeholder
      expect(find.text('--:--'), findsNothing);
    });

    testWidgets('QuestDetailStatusCard without time shows no "--:--"', (tester) async {
      final questWithoutTime = QuestModel(
        id: 'quest_no_time',
        title: 'Quest Without Time',
        description: 'No time fields',
        type: QuestType.custom,
        status: QuestStatus.pending,
        exp: 10,
        estimatedMinutes: 5,
        // No dueDate, no snoozedUntil, no completedAt
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailStatusCard(quest: questWithoutTime),
          ),
        ),
      );

      // Verify no "--:--" placeholder
      expect(find.text('--:--'), findsNothing);
    });

    testWidgets('QuestDetailActionBar for completed quest shows status, not "Bắt Đầu"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailActionBar(quest: completedQuest),
          ),
        ),
      );

      // Verify completed status is shown
      expect(find.text('✓ Đã hoàn thành'), findsOneWidget);

      // Verify "Bắt Đầu" button is NOT shown
      expect(find.text('Bắt Đầu'), findsNothing);
    });

    testWidgets('QuestDetailActionBar for snoozed quest shows "Bắt Đầu"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailActionBar(quest: snoozedQuest),
          ),
        ),
      );

      // Verify "Bắt Đầu" button is shown for snoozed quest
      expect(find.text('Bắt Đầu'), findsOneWidget);
    });

    testWidgets('QuestDetailActionBar for pending quest shows all action buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailActionBar(quest: pendingQuest),
          ),
        ),
      );

      // Verify all action buttons are shown
      expect(find.text('Bắt Đầu'), findsOneWidget);
      expect(find.text('Hoãn'), findsOneWidget);
      expect(find.text('Bỏ Qua'), findsOneWidget);
    });

    testWidgets('QuestDetailActionBar for in-progress quest shows "Hoàn Thành"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestDetailActionBar(quest: inProgressQuest),
          ),
        ),
      );

      // Verify "Hoàn Thành" button is shown
      expect(find.text('Hoàn Thành'), findsOneWidget);
      expect(find.text('Hoãn'), findsOneWidget);
      expect(find.text('Bỏ Qua'), findsOneWidget);
    });

    testWidgets(
      'QuestDetailInstructionCard does not invent type-specific fallback copy',
      (tester) async {
        const quest = QuestModel(
          id: 'water_missing_copy',
          title: 'Water Quest',
          type: QuestType.water,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: QuestDetailInstructionCard(quest: quest)),
          ),
        );

        expect(find.text('Thực hiện nhiệm vụ theo hướng dẫn.'), findsOneWidget);
        expect(find.textContaining('250ml'), findsNothing);
      },
    );
  });
}
