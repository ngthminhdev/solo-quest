class AppGlobal {
  static final AppGlobal _instance = AppGlobal._();
  static AppGlobal get instance => _instance;

  AppGlobal._();

  String? userId;
  String? userName;
  String? avatarUrl;

  void clear() {
    userId = null;
    userName = null;
    avatarUrl = null;
  }
}
