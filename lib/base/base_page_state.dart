abstract class BasePageState {
  final bool isLockedPage;

  BasePageState({this.isLockedPage = false});

  BasePageState updateState({bool? isLockedPage});
}
