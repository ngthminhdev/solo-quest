import 'package:flutter/material.dart';

import '../modules/splash/splash_page.dart';
import '../modules/login/login_page.dart';
import '../modules/welcome/welcome_page.dart';
import '../modules/onboarding/onboarding_page.dart';
import '../modules/main/main_page.dart';
import '../modules/quest_detail/quest_detail_page.dart';
import '../modules/morning_checkin/morning_checkin_page.dart';
import '../modules/daily_review/daily_review_page.dart';
import '../modules/weekly_summary/weekly_summary_page.dart';
import '../modules/schedule_editor/schedule_editor_page.dart';
import '../modules/learning_goals/learning_goals_page.dart';
import '../modules/learning_roadmap/learning_roadmap_page.dart';
import '../modules/reminder_settings/reminder_settings_page.dart';
import '../modules/quest_rules/quest_rules_page.dart';
import 'routes_config.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConfig.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case RoutesConfig.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RoutesConfig.home:
      case RoutesConfig.logs:
      case RoutesConfig.progress:
      case RoutesConfig.rewards:
      case RoutesConfig.profile:
        return MaterialPageRoute(builder: (_) => MainPage());
      case RoutesConfig.questDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final questId = args?['id'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => QuestDetailPage(questId: questId),
        );
      case RoutesConfig.welcome:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case RoutesConfig.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case RoutesConfig.morningCheckin:
        return MaterialPageRoute(builder: (_) => MorningCheckinPage());
      case RoutesConfig.dailyReview:
        return MaterialPageRoute(builder: (_) => DailyReviewPage());
      case RoutesConfig.weeklySummary:
        return MaterialPageRoute(builder: (_) => WeeklySummaryPage());
      case RoutesConfig.scheduleEditor:
        return MaterialPageRoute(builder: (_) => ScheduleEditorPage());
      case RoutesConfig.learningGoals:
        return MaterialPageRoute(builder: (_) => LearningGoalsPage());
      case RoutesConfig.learningRoadmap:
        return MaterialPageRoute(builder: (_) => LearningRoadmapPage());
      case RoutesConfig.reminderSettings:
        return MaterialPageRoute(builder: (_) => ReminderSettingsPage());
      case RoutesConfig.questRules:
        return MaterialPageRoute(builder: (_) => QuestRulesPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
