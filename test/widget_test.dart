import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/routes/routes_config.dart';

void main() {
  test('RoutesConfig has all required routes', () {
    expect(RoutesConfig.splash, '/');
    expect(RoutesConfig.welcome, '/welcome');
    expect(RoutesConfig.onboarding, '/onboarding');
    expect(RoutesConfig.morningCheckin, '/morning-checkin');
    expect(RoutesConfig.home, '/home');
    expect(RoutesConfig.questDetail, '/quest-detail');
    expect(RoutesConfig.logs, '/logs');
    expect(RoutesConfig.progress, '/progress');
    expect(RoutesConfig.dailyReview, '/daily-review');
    expect(RoutesConfig.weeklySummary, '/weekly-summary');
    expect(RoutesConfig.profile, '/profile');
    expect(RoutesConfig.scheduleEditor, '/schedule-editor');
    expect(RoutesConfig.learningGoals, '/learning-goals');
    expect(RoutesConfig.learningRoadmap, '/learning-roadmap');
    expect(RoutesConfig.reminderSettings, '/reminder-settings');
    expect(RoutesConfig.questRules, '/quest-rules');
  });
}
