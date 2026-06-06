import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/generated/l10n/app_localizations.dart';
import 'package:solo_quest/models/learning_roadmap_model.dart';
import 'package:solo_quest/modules/learning_roadmap/widgets/learning_roadmap_empty_view.dart';
import 'package:solo_quest/modules/learning_roadmap/widgets/roadmap_detail_sheet.dart';
import 'package:solo_quest/modules/learning_roadmap/widgets/roadmap_list_section.dart';
import 'package:solo_quest/modules/learning_roadmap/widgets/roadmap_summary_card.dart';

void main() {
  Widget localizedApp(Widget child) {
    return MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('Learning Roadmap UX cleanup', () {
    testWidgets('empty state no longer points to Learning Goals', (
      tester,
    ) async {
      await tester.pumpWidget(localizedApp(const LearningRoadmapEmptyView()));

      expect(find.text('Chưa có lộ trình học'), findsOneWidget);
      expect(
        find.text(
          'Bạn có thể chọn một lộ trình mẫu để bắt đầu theo dõi từng bước học.',
        ),
        findsOneWidget,
      );
      expect(find.text('Mở mục tiêu học tập'), findsNothing);
      expect(find.text('Chọn lộ trình mẫu'), findsNothing);
    });

    testWidgets('roadmap list uses honest template copy', (tester) async {
      final roadmap = LearningRoadmapModel(
        id: 'rm-test',
        title: 'Flutter App Architecture',
        description: 'Roadmap mẫu cho kiến trúc Flutter.',
        steps: const [
          LearningRoadmapStepModel(
            id: 's1',
            title: 'Hiểu MVVM',
            completed: false,
          ),
        ],
      );

      await tester.pumpWidget(
        localizedApp(
          SingleChildScrollView(
            child: Column(
              children: [
                const RoadmapSummaryCard(
                  totalRoadmaps: 1,
                  completedRoadmaps: 0,
                  totalSteps: 1,
                  completedSteps: 0,
                  averageProgress: 0,
                ),
                RoadmapListSection(roadmaps: [roadmap], onOpenRoadmap: (_) {}),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Lộ trình mẫu'), findsOneWidget);
      expect(find.text('Tổng lộ trình'), findsOneWidget);
      expect(find.text('Bước'), findsOneWidget);
      expect(find.text('Đang theo dõi'), findsOneWidget);
      expect(
        find.text(
          'Phiên bản thử nghiệm: tiến độ lộ trình chỉ lưu tạm trên thiết bị.',
        ),
        findsOneWidget,
      );
      expect(find.text('Roadmap của bạn'), findsNothing);
      expect(find.text('Tổng roadmap'), findsNothing);
      expect(find.text('Steps'), findsNothing);
      expect(find.text('Đang học'), findsNothing);
      expect(find.textContaining('AI'), findsNothing);
      expect(find.textContaining('Tạo quest hôm nay'), findsNothing);
      expect(find.textContaining('quest hôm nay'), findsNothing);
    });

    testWidgets('step toggle keeps detail sheet open and updates progress', (
      tester,
    ) async {
      final roadmap = LearningRoadmapModel(
        id: 'rm-test',
        title: 'Flutter App Architecture',
        description: 'Roadmap mẫu cho kiến trúc Flutter.',
        steps: const [
          LearningRoadmapStepModel(
            id: 's1',
            title: 'Hiểu MVVM',
            completed: false,
          ),
          LearningRoadmapStepModel(
            id: 's2',
            title: 'Tạo BasePage',
            completed: true,
          ),
        ],
      );
      var toggleCount = 0;
      Completer<bool>? toggleCompleter;

      await tester.pumpWidget(
        localizedApp(
          Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    RoadmapDetailSheet.show(
                      context,
                      roadmap: roadmap,
                      onToggleStep: (step, completed) async {
                        toggleCount++;
                        toggleCompleter = Completer<bool>();
                        return toggleCompleter!.future;
                      },
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Flutter App Architecture'), findsOneWidget);
      expect(find.text('Tiến độ: 1/2 bước'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);

      await tester.tap(find.text('Hiểu MVVM'));
      await tester.pump();

      expect(toggleCount, 1);
      expect(find.text('Flutter App Architecture'), findsOneWidget);
      expect(find.text('Tiến độ: 2/2 bước'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      toggleCompleter!.complete(true);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Wait for the toast overlay to be removed
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.text('Hiểu MVVM'));
      await tester.pump();

      expect(toggleCount, 2);
      expect(find.text('Flutter App Architecture'), findsOneWidget);
      expect(find.text('Tiến độ: 1/2 bước'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      toggleCompleter!.complete(true);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Wait for the second toast timer/overlay to complete
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
