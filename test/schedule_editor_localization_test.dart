import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/generated/l10n/app_localizations.dart';
import 'package:solo_quest/models/schedule_model.dart';
import 'package:solo_quest/modules/schedule_editor/widgets/schedule_block_card.dart';
import 'package:solo_quest/modules/schedule_editor/widgets/schedule_block_form_sheet.dart';

Widget _localizedApp(Widget child) {
  return MaterialApp(
    locale: const Locale('vi'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('schedule block card renders localized weekdays and badges', (
    tester,
  ) async {
    const block = ScheduleBlockModel(
      id: 'work-block',
      title: 'Lịch làm việc/học tập',
      timeRange: TimeRangeModel(start: '08:30', end: '17:30'),
      weekdays: [1, 2, 3, 4, 5],
      type: 'work',
      isBusy: true,
      isFlexible: false,
    );

    await tester.pumpWidget(
      _localizedApp(
        const Padding(
          padding: EdgeInsets.all(16),
          child: ScheduleBlockCard(block: block),
        ),
      ),
    );

    expect(find.text('Lịch làm việc/học tập'), findsOneWidget);
    expect(find.text('08:30 - 17:30'), findsOneWidget);
    expect(find.text('T2'), findsOneWidget);
    expect(find.text('T3'), findsOneWidget);
    expect(find.text('T4'), findsOneWidget);
    expect(find.text('T5'), findsOneWidget);
    expect(find.text('T6'), findsOneWidget);
    expect(find.text('Bận'), findsOneWidget);
    expect(find.text('Cố định'), findsOneWidget);

    expect(find.text('scheduleEditorWeekdayMon'), findsNothing);
    expect(find.text('scheduleEditorBadgeFixed'), findsNothing);
  });

  testWidgets('schedule edit sheet renders localized form labels and types', (
    tester,
  ) async {
    const block = ScheduleBlockModel(
      id: 'edit-block',
      title: 'Lịch làm việc/học tập',
      timeRange: TimeRangeModel(start: '08:30', end: '17:30'),
      weekdays: [1, 2, 3, 4, 5],
      type: 'work',
      isBusy: true,
      isFlexible: false,
    );

    await tester.pumpWidget(
      _localizedApp(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                ScheduleBlockFormSheet.show(context, initialBlock: block);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Chỉnh sửa khung thời gian'), findsOneWidget);
    expect(find.text('Tiêu đề'), findsOneWidget);
    expect(find.text('Loại lịch'), findsOneWidget);
    expect(find.text('Thời gian'), findsOneWidget);
    expect(find.text('Ngày áp dụng'), findsOneWidget);
    expect(find.text('Đi học'), findsOneWidget);
    expect(find.text('Đi làm'), findsOneWidget);
    expect(find.text('Di chuyển'), findsOneWidget);
    expect(find.text('Ăn uống'), findsOneWidget);
    expect(find.text('Ngủ'), findsOneWidget);
    expect(find.text('Tự học'), findsOneWidget);
    expect(find.text('Cá nhân'), findsOneWidget);
    expect(find.text('Bận'), findsWidgets);
    expect(find.text('Rảnh'), findsOneWidget);
    expect(find.text('Khác'), findsOneWidget);

    expect(find.text('scheduleEditorFormTitleEdit'), findsNothing);
    expect(find.text('scheduleEditorLabelTitle'), findsNothing);
    expect(find.text('scheduleEditorTypeWork'), findsNothing);
  });
}
