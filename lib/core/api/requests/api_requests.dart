import '../../../models/enums/user_enums.dart';

/// Save daily check-in request (simplified 4-field payload)
class SaveDailyCheckinRequest {
  final String date;
  final CheckinMood mood;
  final EnergyLevel energyLevel;
  final Availability availability;
  final CheckinPriority priority;

  SaveDailyCheckinRequest({
    required this.date,
    required this.mood,
    required this.energyLevel,
    required this.availability,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mood': mood.name,
      'energy_level': energyLevel.name,
      'availability': availability.name,
      'priority': priority.name,
    };
  }
}

/// Save daily review request (simplified 6-field payload)
class SaveDailyReviewRequest {
  final String date;
  final String mood;
  final String energyLevel;
  final int satisfaction;
  final String? reflection;
  final String tomorrowPriority;

  SaveDailyReviewRequest({
    required this.date,
    required this.mood,
    required this.energyLevel,
    required this.satisfaction,
    this.reflection,
    required this.tomorrowPriority,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mood': mood,
      'energy_level': energyLevel,
      'satisfaction': satisfaction,
      if (reflection != null && reflection!.isNotEmpty) 'reflection': reflection,
      'tomorrow_priority': tomorrowPriority,
    };
  }
}

/// Complete quest request
class CompleteQuestRequest {
  final String? note;

  CompleteQuestRequest({this.note});

  Map<String, dynamic> toJson() {
    return {
      if (note != null) 'note': note,
    };
  }
}

/// Skip quest request
class SkipQuestRequest {
  final String? reason;

  SkipQuestRequest({this.reason});

  Map<String, dynamic> toJson() {
    return {
      if (reason != null) 'reason': reason,
    };
  }
}

/// Snooze quest request
class SnoozeQuestRequest {
  final int minutes;

  SnoozeQuestRequest({required this.minutes});

  Map<String, dynamic> toJson() {
    return {
      'minutes': minutes,
    };
  }
}
