enum EnergyLevel {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum StressLevel {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum FocusLevel {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum DayIntensity {
  light,
  normal,
  busy,
  overloaded,
}

extension EnergyLevelX on EnergyLevel {
  String get label {
    switch (this) {
      case EnergyLevel.veryLow:
        return 'Rất thấp';
      case EnergyLevel.low:
        return 'Thấp';
      case EnergyLevel.medium:
        return 'Trung bình';
      case EnergyLevel.high:
        return 'Cao';
      case EnergyLevel.veryHigh:
        return 'Rất cao';
    }
  }

  String get iconText {
    switch (this) {
      case EnergyLevel.veryLow:
        return '🪫';
      case EnergyLevel.low:
        return '😴';
      case EnergyLevel.medium:
        return '🙂';
      case EnergyLevel.high:
        return '⚡';
      case EnergyLevel.veryHigh:
        return '🚀';
    }
  }

  int get value => index + 1;
}

extension StressLevelX on StressLevel {
  String get label {
    switch (this) {
      case StressLevel.veryLow:
        return 'Rất thấp';
      case StressLevel.low:
        return 'Thấp';
      case StressLevel.medium:
        return 'Trung bình';
      case StressLevel.high:
        return 'Cao';
      case StressLevel.veryHigh:
        return 'Rất cao';
    }
  }

  String get iconText {
    switch (this) {
      case StressLevel.veryLow:
        return '😌';
      case StressLevel.low:
        return '🙂';
      case StressLevel.medium:
        return '😐';
      case StressLevel.high:
        return '😟';
      case StressLevel.veryHigh:
        return '😵';
    }
  }

  int get value => index + 1;
}

extension FocusLevelX on FocusLevel {
  String get label {
    switch (this) {
      case FocusLevel.veryLow:
        return 'Rất thấp';
      case FocusLevel.low:
        return 'Thấp';
      case FocusLevel.medium:
        return 'Trung bình';
      case FocusLevel.high:
        return 'Cao';
      case FocusLevel.veryHigh:
        return 'Rất cao';
    }
  }

  String get iconText {
    switch (this) {
      case FocusLevel.veryLow:
        return '🌫️';
      case FocusLevel.low:
        return '💤';
      case FocusLevel.medium:
        return '🎯';
      case FocusLevel.high:
        return '🔥';
      case FocusLevel.veryHigh:
        return '🧠';
    }
  }

  int get value => index + 1;
}

extension DayIntensityX on DayIntensity {
  String get label {
    switch (this) {
      case DayIntensity.light:
        return 'Nhẹ nhàng';
      case DayIntensity.normal:
        return 'Bình thường';
      case DayIntensity.busy:
        return 'Bận rộn';
      case DayIntensity.overloaded:
        return 'Quá tải';
    }
  }

  String get description {
    switch (this) {
      case DayIntensity.light:
        return 'Có nhiều thời gian trống';
      case DayIntensity.normal:
        return 'Lịch vừa phải';
      case DayIntensity.busy:
        return 'Có nhiều việc cần làm';
      case DayIntensity.overloaded:
        return 'Rất ít thời gian và năng lượng';
    }
  }

  String get iconText {
    switch (this) {
      case DayIntensity.light:
        return '🌤️';
      case DayIntensity.normal:
        return '⛅';
      case DayIntensity.busy:
        return '🌧️';
      case DayIntensity.overloaded:
        return '⛈️';
    }
  }
}
