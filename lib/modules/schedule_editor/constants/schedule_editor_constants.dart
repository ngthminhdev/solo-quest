import '../../../generated/l10n/app_localizations.dart';

class ScheduleEditorConstants {
  static const String pageTitle = 'scheduleEditorPageTitle';
  static const String pageSubtitle = 'scheduleEditorPageSubtitle';

  static const String sectionTitle = 'scheduleEditorSectionTitle';
  static const String addBlockButton = 'scheduleEditorAddBlockButton';

  static const String emptyTitle = 'scheduleEditorEmptyTitle';
  static const String emptyMessage = 'scheduleEditorEmptyMessage';

  static const String formTitleAdd = 'scheduleEditorFormTitleAdd';
  static const String formTitleCreate = 'scheduleEditorFormTitleCreate';
  static const String formTitleEdit = 'scheduleEditorFormTitleEdit';

  static const String labelTitle = 'scheduleEditorLabelTitle';
  static const String labelType = 'scheduleEditorLabelType';
  static const String labelTime = 'scheduleEditorLabelTime';
  static const String labelStartTime = 'scheduleEditorLabelStartTime';
  static const String labelEndTime = 'scheduleEditorLabelEndTime';
  static const String labelDays = 'scheduleEditorLabelDays';
  static const String labelStatus = 'scheduleEditorLabelStatus';
  static const String labelWeekdays = 'scheduleEditorLabelWeekdays';
  static const String labelFlexible = 'scheduleEditorLabelFlexible';

  static const String badgeBusy = 'scheduleEditorBadgeBusy';
  static const String badgeFree = 'scheduleEditorBadgeFree';
  static const String badgeFixed = 'scheduleEditorBadgeFixed';
  static const String badgeFlexible = 'scheduleEditorBadgeFlexible';
  static const String summaryTotal = 'scheduleEditorSummaryTotal';

  static const String deleteConfirmTitle = 'scheduleEditorDeleteTitle';
  static const String deleteConfirmMessage = 'scheduleEditorDeleteMsg';
  static const String deleteConfirmAction = 'scheduleEditorDeleteConfirmAction';

  static const String buttonSave = 'scheduleEditorButtonSave';
  static const String buttonCancel = 'scheduleEditorButtonCancel';
  static const String buttonDelete = 'scheduleEditorButtonDelete';

  static const String toastAddSuccess = 'scheduleEditorToastAddSuccess';
  static const String toastAddFailed = 'scheduleEditorToastAddFailed';
  static const String toastUpdateSuccess = 'scheduleEditorToastUpdateSuccess';
  static const String toastUpdateFailed = 'scheduleEditorToastUpdateFailed';
  static const String toastDeleteSuccess = 'scheduleEditorToastDeleteSuccess';
  static const String toastDeleteFailed = 'scheduleEditorToastDeleteFailed';

  static const String errorTitleRequired = 'scheduleEditorErrorTitleRequired';
  static const String errorTimeRequired = 'scheduleEditorErrorTimeRequired';
  static const String errorWeekdaysRequired =
      'scheduleEditorErrorWeekdaysRequired';

  static const Map<String, String> blockTypes = {
    'school': 'scheduleEditorTypeSchool',
    'work': 'scheduleEditorTypeWork',
    'commute': 'scheduleEditorTypeCommute',
    'meal': 'scheduleEditorTypeMeal',
    'sleep': 'scheduleEditorTypeSleep',
    'study': 'scheduleEditorTypeStudy',
    'personal': 'scheduleEditorTypePersonal',
    'busy': 'scheduleEditorTypeBusy',
    'free': 'scheduleEditorTypeFree',
    'other': 'scheduleEditorTypeOther',
  };

  static bool defaultIsBusyForType(String type) {
    switch (type) {
      case 'school':
      case 'work':
      case 'commute':
      case 'sleep':
      case 'meal':
      case 'busy':
        return true;
      case 'free':
        return false;
      case 'study':
      case 'personal':
      case 'other':
      default:
        return false;
    }
  }

  static const Map<int, String> weekdayLabels = {
    1: 'scheduleEditorWeekdayMon',
    2: 'scheduleEditorWeekdayTue',
    3: 'scheduleEditorWeekdayWed',
    4: 'scheduleEditorWeekdayThu',
    5: 'scheduleEditorWeekdayFri',
    6: 'scheduleEditorWeekdaySat',
    7: 'scheduleEditorWeekdaySun',
  };

  static String text(AppLocalizations l10n, String key) {
    switch (key) {
      case pageTitle:
        return l10n.scheduleEditorPageTitle;
      case pageSubtitle:
        return l10n.scheduleEditorPageSubtitle;
      case sectionTitle:
        return l10n.scheduleEditorSectionTitle;
      case addBlockButton:
        return l10n.scheduleEditorAddBlockButton;
      case emptyTitle:
        return l10n.scheduleEditorEmptyTitle;
      case emptyMessage:
        return l10n.scheduleEditorEmptyMessage;
      case formTitleAdd:
      case formTitleCreate:
        return l10n.scheduleEditorFormTitleCreate;
      case formTitleEdit:
        return l10n.scheduleEditorFormTitleEdit;
      case labelTitle:
        return l10n.scheduleEditorLabelTitle;
      case labelType:
        return l10n.scheduleEditorLabelType;
      case labelTime:
        return l10n.scheduleEditorLabelTime;
      case labelStartTime:
        return l10n.scheduleEditorLabelStartTime;
      case labelEndTime:
        return l10n.scheduleEditorLabelEndTime;
      case labelDays:
      case labelWeekdays:
        return l10n.scheduleEditorLabelDays;
      case labelStatus:
        return l10n.scheduleEditorLabelStatus;
      case labelFlexible:
        return l10n.scheduleEditorBadgeFlexible;
      case badgeBusy:
        return l10n.scheduleEditorBadgeBusy;
      case badgeFree:
        return l10n.scheduleEditorBadgeFree;
      case badgeFixed:
        return l10n.scheduleEditorBadgeFixed;
      case badgeFlexible:
        return l10n.scheduleEditorBadgeFlexible;
      case summaryTotal:
        return l10n.scheduleEditorSummaryTotal;
      case deleteConfirmTitle:
        return l10n.scheduleEditorDeleteConfirmTitle;
      case deleteConfirmMessage:
        return l10n.scheduleEditorDeleteConfirmMessage;
      case deleteConfirmAction:
        return l10n.scheduleEditorDeleteConfirmAction;
      case buttonSave:
        return l10n.scheduleEditorButtonSave;
      case buttonCancel:
        return l10n.scheduleEditorButtonCancel;
      case buttonDelete:
        return l10n.scheduleEditorButtonDelete;
      case toastAddSuccess:
        return l10n.scheduleEditorToastAddSuccess;
      case toastAddFailed:
        return l10n.scheduleEditorToastAddFailed;
      case toastUpdateSuccess:
        return l10n.scheduleEditorToastUpdateSuccess;
      case toastUpdateFailed:
        return l10n.scheduleEditorToastUpdateFailed;
      case toastDeleteSuccess:
        return l10n.scheduleEditorToastDeleteSuccess;
      case toastDeleteFailed:
        return l10n.scheduleEditorToastDeleteFailed;
      case errorTitleRequired:
        return l10n.scheduleEditorErrorTitleRequired;
      case errorTimeRequired:
        return l10n.scheduleEditorErrorTimeRequired;
      case errorWeekdaysRequired:
        return l10n.scheduleEditorErrorWeekdaysRequired;
      default:
        return key;
    }
  }

  static String blockTypeLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'school':
        return l10n.scheduleEditorTypeSchool;
      case 'work':
        return l10n.scheduleEditorTypeWork;
      case 'commute':
        return l10n.scheduleEditorTypeCommute;
      case 'meal':
        return l10n.scheduleEditorTypeMeal;
      case 'sleep':
        return l10n.scheduleEditorTypeSleep;
      case 'study':
        return l10n.scheduleEditorTypeStudy;
      case 'personal':
        return l10n.scheduleEditorTypePersonal;
      case 'busy':
        return l10n.scheduleEditorTypeBusy;
      case 'free':
        return l10n.scheduleEditorTypeFree;
      case 'other':
      default:
        return l10n.scheduleEditorTypeOther;
    }
  }

  static String weekdayLabel(AppLocalizations l10n, int day) {
    switch (day) {
      case 1:
        return l10n.scheduleEditorWeekdayMon;
      case 2:
        return l10n.scheduleEditorWeekdayTue;
      case 3:
        return l10n.scheduleEditorWeekdayWed;
      case 4:
        return l10n.scheduleEditorWeekdayThu;
      case 5:
        return l10n.scheduleEditorWeekdayFri;
      case 6:
        return l10n.scheduleEditorWeekdaySat;
      case 7:
        return l10n.scheduleEditorWeekdaySun;
      default:
        return '';
    }
  }
}
