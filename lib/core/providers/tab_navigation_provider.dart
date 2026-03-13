import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_navigation_provider.g.dart';

/// 하단 탭의 순서와 동일하게 유지합니다.
/// StatefulShellBranch 순서: library(0), home(1), myPage(2)
enum AppTab { library, home, myPage }

/// 탭이 탭될 때마다 발행되는 이벤트.
/// seq가 매번 증가하므로 같은 탭을 반복 선택해도 리스너가 반응합니다.
typedef TabTapEvent = ({int seq, AppTab tab});

@riverpod
class TabNavigationNotifier extends _$TabNavigationNotifier {
  @override
  TabTapEvent? build() => null;

  void onTabTapped(AppTab tab) {
    state = (seq: (state?.seq ?? 0) + 1, tab: tab);
  }
}
